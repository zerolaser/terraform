resource "aws_iam_group" "group" {
    name = "cloudacademy"
    path = "/"
}
resource "aws_iam_group_membership" "membership" {
    name = "cloudacademy_join"
    users = [ 
        "${aws_iam_user.satya.name}"
    ]
    group = "${aws_iam_group.group.name}"
}

output "group" {
    value = "${aws_iam_group.group.name}"
}
