#!/bin/bash

source .diaryrc

diary-make-home-dir()
	{
	mkdir -p $DIARY_PATH
	}
	
diary-create()
	{
	diary-make-home-dir
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
	dateFirstNote=`echo $fileName | cut -b 10-25`
	textFirstPath=`find $DIARY_PATH -depth -name "$fileName.md"`
	textFirstNote=$(<$textFirstPath)
	echo "Создана задача: id - $id дата и время - $dateFirstNote содержимое - $textFirstNote"
	cd 
	}

diary-open()
	{
	echo "Введите ID записи"
	read idR
	allFilesO=`ls -tR $DIARY_PATH | grep "\.md"`
	arrAllFilesO=(${allFilesO// /})

	for j in ${arrAllFilesO[@]}; do
	   keyForOpen=`echo $j | cut -f 1 -d'_'` 
	   if [ "$keyForOpen" == "$idR" ]; then
		 idForOpen=`find $DIARY_PATH -depth -name "$j"`
		 taskForOpen=$(<$idForOpen)
		 output="$keyForOpen $taskForOpen"
	   fi
	done
   if [ -n "$output" ]; then 
		echo "$output"
	else
   echo "Такой записи нет"
   fi
	output=""
	}


diary-delete()
	{
	cd $DIARY_PATH
	mkdir -p basket
	echo "Введите id задачи для удаления"
	read fileD

	cd
	forDel=`ls -tR | grep "\.md"`
	arrforDel=(${forDel// /})
	for l in ${arrforDel[@]}; do
   	keyForDelete=`echo $l | cut -b 1-8`
   	yearForDelete=`echo $l | cut -b 10-13`
	monthForDeleteDecimal=`echo $l | cut -b 15-16`
   	
	case "$monthForDeleteDecimal" in
	"01" ) monthForDelete="January";;
	"02" ) monthForDelete="February";;
	"03" ) monthForDelete="March";;
	"04" ) monthForDelete="April";;
	"05" ) monthForDelete="May";;
	"06" ) monthForDelete="Jun";;
	"07" ) monthForDelete="July";;
	"08" ) monthForDelete="August";;
	"09" ) monthForDelete="September";;
	"10" ) monthForDelete="October";;
	"11" ) monthForDelete="November";;
	"12" ) monthForDelete="December";;
	esac

	 if [ "$fileD" == "$keyForDelete" ]; then
	 mv $DIARY_PATH/$yearForDelete/$monthForDelete/$l $DIARY_PATH/basket
	 fi   	

   	done
}

diary-show-basket()
	{
	cd
	mkdir -p $DIARY_PATH/basket
	cd $DIARY_PATH/basket
	basket=`ls -tR $DIARY_PATH | grep "\.md"`
	arrBas=(${basket// /})
	for l in ${arrBas[@]}; do
   	keyBasket=`echo $l | cut -b 1-8`
   	dateKeyBasket=`echo $l | cut -b 10-19`
   	keyInBasket=`find $DIARY_PATH -depth -name "$l"`
   	taskInBasket=$(<$keyInBasket)
   	echo "$keyB $dateKeyBasket $taskInBasket"
	done
	cd
	}

diary-restore()
	{
	cd
	cd $DIARY_PATH/basket
	echo "Введите id задачи для восстановления"
	read filevs

	forRes=`ls -tR | grep "\.md"`
	arrforRes=(${forRes// /})
	for l in ${arrforRes[@]}; do
   	keyForRestore=`echo $l | cut -b 1-8`
   	yearForRestore=`echo $filevs | cut -b 10-13`
	monthForRestoreDecimal=`echo $filevs | cut -b 15-16`

	case "$monthForRestoreDecimal" in
	"01" ) monthForRestore="January";;
	"02" ) monthForRestore="February";;
	"03" ) monthForRestore="March";;
	"04" ) monthForRestore="April";;
	"05" ) monthForRestore="May";;
	"06" ) monthForRestore="Jun";;
	"07" ) monthForRestore="July";;
	"08" ) monthForRestore="August";;
	"09" ) monthForRestore="September";;
	"10" ) monthForRestore="October";;
	"11" ) monthForRestore="November";;
	"12" ) monthForRestore="December";;
	esac
	
	 if [ "$filevs" == "$keyForRestore" ]; then
	 mv $DIARY_PATH/basket/$l $DIARY_PATH/$yearForRestore/$monthForRestore
	 fi   	
   	done

	cd
	}

diary-show-last5()
	{
	echo "Последние 5 записей:"
	cd
	last5=`ls -tR $DIARY_PATH | grep "\.md" | head -5`
	array=(${last5// /})
	for i in ${array[@]}; do
  	key=`echo $i | cut -b 1-8`
   	dateKey=`echo $i | cut -b 10-19`
   	var=`find $DIARY_PATH -depth -name "$i"`
   	task=$(<$var)
   	echo "$key $dateKey $task"
   
	done

	}

diary-show-tasks()
	{
	echo "Активные задачи"
	cd
	active=`ls -tR $DIARY_PATH | grep "\.md"`
	arrayActive=(${active// /})
	for l in ${arrayActive[@]}; do
  	keyActive=`echo $l | cut -b 1-8`
  	dateKeyAktive=`echo $l | cut -b 10-19`
   	varActive=`find $DIARY_PATH -depth -name "$l"`
   	taskActive=$(<$varActive)
   	echo "$keyActive $dateKeyAktive $taskActive"
   
	done

	}


diary-get-stat()
	{
	cd
	allFiles=`ls -tR $DIARY_PATH | grep "\.md"`
	arrAllFiles=(${allFiles// /})
	echo "Количество записей в дневнике: ${#arrAllFiles[@]}"
	lastNote=`echo ${arrAllFiles[0]} | cut -b 10-25`
	zap=`find $DIARY_PATH -depth -name "${arrAllFiles[0]}"`
  	lastTask=$(<$zap)
	echo "Последняя запись была сделана (год-месяц-число-час-минута) текст записи"
	echo "$lastNote $lastTask"
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

diary-help()
	{
	echo "Список доступных команд:"
	echo "diary-сreate – создать запись"
	echo "diary-open – открыть запись"
	echo "diary-delete – удалить запись"
	echo "diary-show-tasks – показать активные задачи"
	echo "diary-restore – восстановить запись"
	echo "diary-show-basket – просмотреть содержимое корзины"
	echo "diary-show-last5 – показать последние 5 записей"
	echo "diary-get-stat – просмотреть статистику"
	}




