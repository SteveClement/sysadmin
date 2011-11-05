<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
 <title><?= php_uname(); ?>: stats</title>
</head>

<body>

<?php
$d = dir(".");

while (false !== ($entry = $d->read())) {

	if ( ereg('.html',$entry) == true ) {
		echo "<a href=\"$entry\">$entry</a><br />\n";
	}
}
   
$d->close(); ?> 

</body>
</html>
