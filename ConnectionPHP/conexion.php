<?php

$connect = new mysqli("localhost", "root", "", "gamusers");
if (!$connect) {
    echo "erro verifique ip";
    exit();
}
