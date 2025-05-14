package spacelift
import future.keywords

prd_stack_label = {"prd"}

required_labels_all = {"uat", "prd", "dev","sbx","poc"}
env_label_missing {count({label | label := input.stack.labels[_]; label in required_labels_all}) == 0}
reject {env_label_missing}

flag["This stack needs to have a 'uat', 'dev', 'prd', 'sbx' or 'poc' label attached to continue. Please go to stack settings to add this."] {
env_label_missing
}

not_prd {count({label | label := input.stack.labels[_]; label in prd_stack_label}) == 0}
approve {not_prd}
approve {    count(input.reviews.current.approvals) = 1}
reject {count(input.reviews.current.rejections) = 1}

sample = true
