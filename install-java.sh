#!/bin/sh

# Chcek Root Privileges
if [ "$EUID" -ne 0 ]; then
  echo -e "\e[31mERROR: Please run as root (sudo).\e[0m"
  exit
fi

# Java Versions to Install
JAVA_VERSIONS=("8" "11" "16" "17")

# Update Repositories
echo -e "\e[96mUpdating Repositories\e[0m"
apt-get update -y

# Install Java Versions
for v in ${JAVA_VERSIONS[@]}; do
  echo -e "\e[96mInstalling Java $v\e[0m"
  apt-get install openjdk-$v-jre -y
done

# Create Hard Links
for v in ${JAVA_VERSIONS[@]}; do
  FILE=/usr/bin/java$v
  if [ -f "$FILE" ]; then
    echo -e "\e[93mSkipped hard link for java$v: File \"$FILE\" already exists.\e[0m"
  else
    ln -s /lib/jvm/java-$v-openjdk-amd64/bin/java $FILE
    echo -e "\e[96mCreated hard link for java$v at \"$FILE\"\e[0m"
  fi
done