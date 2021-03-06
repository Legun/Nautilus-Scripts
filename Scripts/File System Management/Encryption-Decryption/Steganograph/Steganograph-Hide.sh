#!/bin/bash




step1=$(zenity  --file-selection --title="Select a .png image (no spaces in path or filename)!" --filename=$HOME/)

						      if [ "$?" -eq "0" ]
       									 then

file_ext=`echo $step1 |awk -F . '{print $NF}'`


if  [ "$file_ext" = "png" ];

                            then

step2=$(zenity  --file-selection --title="Select file that you wanna hide into your image(no spaces path/filename)!" --filename=$HOME/)
							 if [ "$?" -eq "0" ]
							 then
pass=$(zenity --password --title  "Enter password: " --width 300)
img_name=$(zenity --title  "Enter a name:!"  --entry --text="This will be picture name!" --width 300 --height 200)

zip -P $pass archive $step2

cat $step1 archive.zip > ~/Temp/$img_name.png
rm -f archive.zip
echo -e " You can find your image in $HOME/Temp \n$step2 successfuly added to $img_name.png" 2>&1 | zenity --text-info --title "Success" --width 300 --height 200
exit 0
                                       				else
                                       				exit 0
                                       				fi


elif [ "$file_ext" = "jpg" ];

                            then

step2=$(zenity  --file-selection --title="Select file that you wanna hide into your image(no spaces path/filename))!" --filename=$HOME/)
							if [ "$?" -eq "0" ]
							 then
pass=$(zenity --password --title  "Enter password: " --width 300)
        img_name=$(zenity --title  "Enter a name:!"  --entry --text="This will be picture name!" --width 300 --height 200)
zip -P $pass archive $step2

cat $step1 archive.zip > ~/Temp/$img_name.jpg
rm -f archive.zip
echo -e " You can find your image in $HOME/Temp \n$step2 successfuly added to $img_name.jpg" 2>&1 | zenity --text-info --title "Success" --width 300 --height 200
exit 0
       							 else
                                       				exit 0
                                       				fi


        elif [ "$file_ext" = "bmp" ];

                            then

step2=$(zenity  --file-selection --title="Select file that you wanna hide into your image(no spaces path/filename)!" --filename=$HOME/)
						if [ "$?" -eq "0" ]
							 then
	pass=$(zenity --password --title  "Enter password: " --width 300)
 img_name=$(zenity --title  "Enter a name:!"  --entry --text="This will be picture name!" --width 300 --height 200)
zip -P $pass archive $step2

cat $step1 archive.zip > ~/Temp/$img_name.bmp
rm -f archive.zip
echo -e " You can find your image in $HOME/Temp \n$step2 successfuly added to $img_name.bmp" 2>&1 | zenity --text-info --title "Success" --width 300 --height 200
exit 0

							else
                                       				exit 0
                                       				fi

else
echo "Image Not supported!!\nOnly png,jpg &bmp!!" 2>&1 | zenity --text-info --title "Error" --width 200 --height 200
fi
exit 0


								else
								exit 0
								fi
