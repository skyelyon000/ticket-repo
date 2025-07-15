package spacelift

import future.keywords.in

requires_approval {
  input.run.state == "UNCONFIRMED"
}

approve {
	not requires_approval
}

# Get the user ID of the person who triggered the run
run_creator := input.run.triggered_by

approvals := input.reviews.current.approvals

# Check if any approval is a self-approval
self_approval {
  some i
  approvals := input.reviews.current.approvals
  approvals[i].author == run_creator
  count(input.reviews.current.approvals) < 2
}

# dcom_admin_approval {
#   "Spacelift - DCOM - Admins" in approvals[_].session.teams
# }

# Check if any approver is in the proper group
dcom_admin_approval {
  some i
  approvals := input.reviews.current.approvals
  "Spacelift - DCOM - Admins" in approvals[i].session.teams
}

# Deny approval if it's a self-approval
deny[msg] {
  requires_approval
  self_approval
  msg := "You cannot approve your own run."
}

approve {
  requires_approval
  dcom_admin_approval
  not self_approval
  count(input.reviews.current.rejections) == 0
  not self_approval
}

sample := true
