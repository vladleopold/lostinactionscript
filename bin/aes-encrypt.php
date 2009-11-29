<?php 
  // from www.movable-type.co.uk/scripts/aes-php.html 

  require 'aes-lib.php';  
  
  echo AESEncryptCtr($_POST['plain'], $_POST['key'], 256);
?> 