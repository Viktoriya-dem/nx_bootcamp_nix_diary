#!/bin/bash

source .diaryrc

create ()
	{
	mkdir -p $DIARY_PATH
	year=$(date +%Y)
	month=$(date +%B)
	id=$(head -c 100 /dev/urandom | base64 | sed 's/[+=/A-Z]//g' | tail -c 9)
	fileName=$id\_$(date +%Y-%m-%d-%H-%M)
	cd $DIARY_PATH
	mkdir -p $year
	cd $year
	mkdir -p $month
	cd $month
	nano $fileName.md

	cd 
	}

open()
	{
	echo "Введите ID записи"
	read idR
	allFilesO=`ls -tR | grep "\.md"`
	arrAllFilesO=(${allFilesO// /})

	for j in ${arrAllFilesO[@]}; do
	   key1=`echo $j | cut -f 1 -d'_'` 
	   if [ "$key1" == "$idR" ]; then
		 var1=`find / -depth -name "$j"`
		 task1=$(<$var1)
		 vivod="$key1 $task1"
	   fi
	done
   if [ -n "$vivod" ]; then 
		echo "$vivod"
	else
   echo "Такой записи нет"
   fi
	vivod=""
	}


delete()
	{
	cd $DIARY_PATH
	mkdir -p basket
	"Введите имя файла для удаления"
	read fileD
	year2=`echo $fileD | cut -b 10-13`
	month3=`echo $fileD | cut -b 15-16`
	case "$month3" in
	"01" ) month4="January";;
	"02" ) month4="February";;
	"03" ) month4="March";;
	"04" ) month4="April";;
	"05" ) month4="May";;
	"06" ) month4="Jun";;
	"07" ) month4="July";;
	"08" ) month4="August";;
	"09" ) month4="September";;
	"10" ) month4="October";;
	"11" ) month4="November";;
	"12" ) month4="December";;
	esac
	mv $DIARY_PATH/$year2/$month4/$fileD $DIARY_PATH/basket
	
}

showBasket()
	{
	cd
	cd $DIARY_PATH/basket
	basket=`ls -tR | grep "\.md"`
	echo $basket
	cd
	}

restore()
	{
	cd
	cd $DIARY_PATH/basket
	echo "Введите имя файла для восстановления"
	read filevs
	year1=`echo $filevs | cut -b 10-13`
	month1=`echo $filevs | cut -b 15-16`
	case "$month1" in
	"01" ) month2="January";;
	"02" ) month2="February";;
	"03" ) month2="March";;
	"04" ) month2="April";;
	"05" ) month2="May";;
	"06" ) month2="Jun";;
	"07" ) month2="July";;
	"08" ) month2="August";;
	"09" ) month2="September";;
	"10" ) month2="October";;
	"11" ) month2="November";;
	"12" ) month2="December";;
	esac
	
	mv $DIARY_PATH/basket/$filevs $DIARY_PATH/$year1/$month2
	cd

	}

showLast5()
{
echo "Последние 5 записей:"
cd
last5R=`ls -tR | grep "\.md" | head -5`
array=(${last5R// /})
for i in ${array[@]}; do
   key=`echo $i | cut -b 1-8`
   dateKey=`echo $i | cut -b 10-19`
   var=`find / -depth -name "$i"`
   task=$(<$var)
   echo "$key $dateKey $task"
   
done

}

showTasks()
{
echo "Активные задачи"
cd
active=`ls -tR | grep "\.md"`
arrayActive=(${active// /})
for l in ${arrayActive[@]}; do
   key1=`echo $l | cut -b 1-8`
   dateKey1=`echo $l | cut -b 10-19`
   varActive=`find / -depth -name "$l"`
   taskActive=$(<$varActive)
   echo "$key1 $dateKey1 $taskActive"
   
done

}


getStat()
{
cd
allFiles=`ls -tR | grep "\.md"`
arrAllFiles=(${allFiles// /})
echo "Количество записей в дневнике: ${#arrAllFiles[@]}"
last=`echo ${arrAllFiles[0]} | cut -b 10-25`
zap=`find / -depth -name "${arrAllFiles[0]}"`
   tasklast=$(<$zap)
echo "Последняя запись была сделана (год-месяц-число-час-минута) текст записи"
echo "$last $tasklast"
col=0
for k in ${arrAllFiles[@]}; do
   varL=`echo $k | cut -b 1-8`
   var2=`find / -depth -name "$k"`
   taskL=$(<$var2)
   colN=`wc -m $var2`
   colNN=`echo $colN | cut -f 1 -d ' '`
   if (( colNN > col )); then
   col=$colNN
   vL=$taskL
   tL=$varL
   fi   
done

echo "Самая длинная запись в дневнике: $tL $vL" 
unset arrAllFiles
col=0
varL=""
var2=""
taslL=""
colN=""
colNN=""
vl=""
}


