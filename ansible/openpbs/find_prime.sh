#!/bin/bash

#storing the number to be checked
number=44443
i=2

#flag variable
f=0

#running a loop from 2 to number/2
while test $i -le `expr $number / 2`
do
        if test `expr $number % $i` -eq 0
        then
                f=1
        fi

        #increment the loop variable
        i=`expr $i + 1`
done
if test $f -eq 1
then
        echo "$number is Not Prime"
else
        echo "$number is Prime"
fi
