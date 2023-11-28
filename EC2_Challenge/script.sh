# Run a script on the web server that installs Apache and creates a simple index.html file
# This script is run as the ec2-user

# Install Apache
yum install -y httpd

# Start Apache
service httpd start

# Create a simple index.html file
echo "<html><h1>Hello World</h1></html>" > /var/www/html/index.html

# Make sure Apache restarts after reboot
chkconfig httpd on