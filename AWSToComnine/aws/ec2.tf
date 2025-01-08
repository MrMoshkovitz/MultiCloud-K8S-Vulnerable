#*#################################################################################
#?                                      App1 - Vulny
#*#################################################################################

#?                                      App1 - Vulny
#*#################################################################################
#?                                      AWS EC2 - Ubuntu Server 16.04
#*#################################################################################

resource "aws_instance" "app1" {
    ami = var.ami1
    instance_type = "t3.micro"
    associate_public_ip_address = true
    subnet_id = aws_subnet.app1.id
    monitoring = false
    vpc_security_group_ids = [aws_security_group.app1.id]
    root_block_device {
        volume_size           = 100
        volume_type           = "gp3"
        delete_on_termination = "true"
        encrypted = false
        throughput = 200

    }    

    user_data = <<EOF
#! /bin/bash
export AWS_ACCESS_KEY_ID=**********************
export AWS_SECRET_ACCESS_KEY=**********************
EOF
}

#?                                      AWS EC2 - Instace Volume
#*#################################################################################
resource "aws_ebs_volume" "app1" {
  # unencrypted volume
    availability_zone = "${var.region}a"
    encrypted         = false  # Setting this causes the volume to be recreated on apply 
    size = 1

}
#?                                      AWS EC2 - Instace Volume Attachment
#*#################################################################################
resource "aws_volume_attachment" "app1" {
    device_name = "/dev/sdh"
    volume_id   = aws_ebs_volume.app1.id
    instance_id = aws_instance.app1.id
}




data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "db_app" {
  # ec2 have plain text secrets in user data
  ami                  = data.aws_ami.amazon-linux-2.id
  instance_type        = "t2.nano"
  iam_instance_profile = aws_iam_instance_profile.db_ec2_profile.name

  vpc_security_group_ids = [
  aws_security_group.app1.id]
  subnet_id = aws_subnet.app1.id
  user_data = <<EOF
#! /bin/bash
### Config from https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Tutorials.WebServerDB.CreateWebServer.html
sudo yum -y update
sudo yum -y install httpd php php-mysqlnd
sudo systemctl enable httpd 
sudo systemctl start httpd

sudo mkdir /var/www/inc
cat << EnD > /tmp/dbinfo.inc
<?php
define('DB_SERVER', '${aws_db_instance.db_instance.endpoint}');
define('DB_USERNAME', '${aws_db_instance.db_instance.username}');
define('DB_PASSWORD', '${var.password}');
define('DB_DATABASE', '${aws_db_instance.db_instance.name}');
?>
EnD
sudo mv /tmp/dbinfo.inc /var/www/inc 
sudo chown root:root /var/www/inc/dbinfo.inc

cat << EnD > /tmp/index.php
<?php include "../inc/dbinfo.inc"; ?>
<html>
<body>
<h1>Sample page</h1>
<?php

  /* Connect to MySQL and select the database. */
  \$connection = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD);

  if (mysqli_connect_errno()) echo "Failed to connect to MySQL: " . mysqli_connect_error();

  \$database = mysqli_select_db(\$connection, DB_DATABASE);

  /* Ensure that the EMPLOYEES table exists. */
  VerifyEmployeesTable(\$connection, DB_DATABASE);

  /* If input fields are populated, add a row to the EMPLOYEES table. */
  \$employee_name = htmlentities(\$_POST['NAME']);
  \$employee_address = htmlentities(\$_POST['ADDRESS']);

  if (strlen(\$employee_name) || strlen(\$employee_address)) {
    AddEmployee(\$connection, \$employee_name, \$employee_address);
  }
?>

<!-- Input form -->
<form action="<?PHP echo \$_SERVER['SCRIPT_NAME'] ?>" method="POST">
  <table border="0">
    <tr>
      <td>NAME</td>
      <td>ADDRESS</td>
    </tr>
    <tr>
      <td>
        <input type="text" name="NAME" maxlength="45" size="30" />
      </td>
      <td>
        <input type="text" name="ADDRESS" maxlength="90" size="60" />
      </td>
      <td>
        <input type="submit" value="Add Data" />
      </td>
    </tr>
  </table>
</form>

<!-- Display table data. -->
<table border="1" cellpadding="2" cellspacing="2">
  <tr>
    <td>ID</td>
    <td>NAME</td>
    <td>ADDRESS</td>
  </tr>

<?php

\$result = mysqli_query(\$connection, "SELECT * FROM EMPLOYEES");

while(\$query_data = mysqli_fetch_row(\$result)) {
  echo "<tr>";
  echo "<td>",\$query_data[0], "</td>",
       "<td>",\$query_data[1], "</td>",
       "<td>",\$query_data[2], "</td>";
  echo "</tr>";
}
?>

</table>

<!-- Clean up. -->
<?php

  mysqli_free_result(\$result);
  mysqli_close(\$connection);

?>

</body>
</html>


<?php

/* Add an employee to the table. */
function AddEmployee(\$connection, \$name, \$address) {
   \$n = mysqli_real_escape_string(\$connection, \$name);
   \$a = mysqli_real_escape_string(\$connection, \$address);

   \$query = "INSERT INTO EMPLOYEES (NAME, ADDRESS) VALUES ('\$n', '\$a');";

   if(!mysqli_query(\$connection, \$query)) echo("<p>Error adding employee data.</p>");
}

/* Check whether the table exists and, if not, create it. */
function VerifyEmployeesTable(\$connection, \$dbName) {
  if(!TableExists("EMPLOYEES", \$connection, \$dbName))
  {
     \$query = "CREATE TABLE EMPLOYEES (
         ID int(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
         NAME VARCHAR(45),
         ADDRESS VARCHAR(90)
       )";

     if(!mysqli_query(\$connection, \$query)) echo("<p>Error creating table.</p>");
  }
}

/* Check for the existence of a table. */
function TableExists(\$tableName, \$connection, \$dbName) {
  \$t = mysqli_real_escape_string(\$connection, \$tableName);
  \$d = mysqli_real_escape_string(\$connection, \$dbName);

  \$checktable = mysqli_query(\$connection,
      "SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME = '\$t' AND TABLE_SCHEMA = '\$d'");

  if(mysqli_num_rows(\$checktable) > 0) return true;

  return false;
}
?>               
EnD

sudo mv /tmp/index.php /var/www/html
sudo chown root:root /var/www/html/index.php



EOF
}

output "db_app_public_dns" {
  description = "DB Public DNS name"
  value       = aws_instance.db_app.public_dns
}

output "db_endpoint" {
  description = "DB Endpoint"
  value       = aws_db_instance.db_instance.endpoint
}
