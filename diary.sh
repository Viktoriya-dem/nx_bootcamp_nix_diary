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
	dateFirst=`echo $fileName | cut -b 10-25`
	textFirst1=`find $DIARY_PATH -depth -name "$fileName.md"`
	textFirst=$(<$textFirst1)
	echo "Создана задача: id - $id дата и время - $dateFirst содержимое - $textFirst"
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
		 var1=`find $DIARY_PATH -depth -name "$j"`
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
	echo "Введите id задачи для удаления"
	read fileD

	cd
	forDel=`ls -tR | grep "\.md"`
	arrforDel=(${forDel// /})
	for l in ${arrforDel[@]}; do
   	key1=`echo $l | cut -b 1-8`
   	year2=`echo $l | cut -b 10-13`
	month3=`echo $l | cut -b 15-16`
   	
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

	 if [ "$fileD" == "$key1" ]; then
	 mv $DIARY_PATH/$year2/$month4/$l $DIARY_PATH/basket
	 fi   	

   	done
}

showBasket()
	{
	cd
	mkdir -p $DIARY_PATH/basket
	cd $DIARY_PATH/basket
	basket=`ls -tR | grep "\.md"`
	arrBas=(${basket// /})
	for l in ${arrBas[@]}; do
   	keyB=`echo $l | cut -b 1-8`
   	dateKeyB=`echo $l | cut -b 10-19`
   	varActiveB=`find $DIARY_PATH -depth -name "$l"`
   	taskActiveB=$(<$varActiveB)
   	echo "$keyB $dateKeyB $taskActiveB"
   
	done
	cd
	}

restore()
	{
	cd
	cd $DIARY_PATH/basket
	echo "Введите id задачи для восстановления"
	read filevs

	forRes=`ls -tR | grep "\.md"`
	arrforRes=(${forRes// /})
	for l in ${arrforRes[@]}; do
   	key2=`echo $l | cut -b 1-8`
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
	
	 if [ "$filevs" == "$key2" ]; then
	 mv $DIARY_PATH/basket/$l $DIARY_PATH/$year1/$month2
	 fi   	
   	done

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
   	var=`find $DIARY_PATH -depth -name "$i"`
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
   	varActive=`find $DIARY_PATH -depth -name "$l"`
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
	zap=`find $DIARY_PATH -depth -name "${arrAllFiles[0]}"`
  	tasklast=$(<$zap)
	echo "Последняя запись была сделана (год-месяц-число-час-минута) текст записи"
	echo "$last $tasklast"
	col=0
	for k in ${arrAllFiles[@]}; do
   	varL=`echo $k | cut -b 1-8`
   	var2=`find $DIARY_PATH -depth -name "$k"`
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

helpDiary()
	{
	echo "Список доступных команд:"
	echo "сreate – создать запись"
	echo "open – открыть запись"
	echo "delete – удалить запись"
	echo "showTasks – показать активные задачи"
	echo "restore – восстановить запись"
	echo "showBasket – просмотреть содержимое корзины"
	echo "showLast5 – показать последние 5 записей"
	echo "getStat – просмотреть статистику"
	}


