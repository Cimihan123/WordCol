


Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White
NC='\033[0m' # No Color

echo ${Cyan}"

          __        __   ___    ____    ____     ____    ___    _     
          \ \      / /  / _ \  |  _ \  |  _ \   / ___|  / _ \  | |    
           \ \ /\ / /  | | | | | |_) | | | | | | |     | | | | | |    
            \ V  V /   | |_| | |  _ <  | |_| | | |___  | |_| | | |___ 
             \_/\_/     \___/  |_| \_\ |____/   \____|  \___/  |_____|
                                                                      
 

                                                             By-Cimihan

"${NC}
echo ${Red}"*---  ---*---  ---*---  ---*---  ---*---  ---*---  ---*---  ---*---  ---*"${NC}
Usage(){
        while read -r line; do
                printf "%b\n" "$line"
        done  <<-EOF
\r ${Green}|- ${NC} ${Yellow} -d/--domain\t Domain to extract endpoints
\r ${Green}|- ${NC} ${Yellow} -dd/--domains\t Give List of  Domains file to extract endpoints
\r ${Green}|- ${NC} ${Yellow} -f/--file\t Give urls file


EOF
 exit 1
}






#Gau file or wayback file or hakcrawl or anyother related file for extracting endpoints

urlsFile(){

    echo "${Yellow}urlsFile${NC}"
    echo "\n"

   
    cat $file | unfurl -u keys  | tee file.txt
    cat $file | unfurl -u paths | tee -a file.txt
    sed 's#/#\n#g' file.txt  | sort -u | tee -a endpoints.txt   


    mkdir endpoint/
    cat $file | head -n 1000 | fff -s 200 -s 404 -o out
    grep -roh "\"\/[a-zA-Z0-9_/?=&]*\"" out/ | sed -e 's/^"//' -e 's/"$//' | sort -u | tee -a endpoints.txt

    #sorting
   
    cat endpoints.txt | grep -iv '.css$\|.png$\|.jpeg$\|.jpg$\|.svg$\|.gif$\|.woff$\|.woff2$\|.bmp$\|.mp4$\|.mp3$\|.js$'  | tee -a endpoint/wordlists.txt


    rm file.txt
    rm -rdf out/





	#checking if starting word is '/' or not
	for i in $(cat endpoint/wordlists.txt);do
	    starting=$(echo $i | awk '{print substr ($0,0,1)}' )
	    if [ $starting = '/' ];then
		echo $i >> do.txt
	    else
		echo '/'$i >> do.txt
	    fi

	done

	#checking if ending word is '/' or not

	for i in $(cat do.txt);do
	    end=$(echo $i | awk '{print substr ($0,length,1)}' )
	    if [ $end = '/' ];then
		echo $i | rev | cut -c 2-  |rev  >> endpoint/wordlist.txt
	    else
		echo $i >> endpoint/wordlist.txt
	    fi

	done

    sort -u endpoint/wordlist.txt   > endpoint/endpoints.txt
    rm do.txt endpoints.txt  endpoint/wordlist.txt endpoint/wordlists.txt






}



#Single domains



Endpoints() {



        echo "${Yellow}Endpoints${NC}"
        echo "\n"
        gau $domain | tee gau.txt | unfurl -u keys | tee -a wordlist.txt ; gau $domain | unfurl -u paths|tee -a ends.txt; sed 's#/#\n#g' ends.txt  | sort -u | tee -a wordlist.txt | sort -u ;rm ends.txt  | sed -i -e 's/\.css\|\.png\|\.jpeg\|\.jpg\|\.svg\|\.gif\|\.wolf\|\.bmp//g' wordlist.txt

    

         rm gau.txt

}



curling() {


        echo "${Yellow}Curling${NC}"
        echo '\n'
        echo $domain | httpx -threads 4 -o http.txt
        curl https://tools.ietf.org/html/rfc1866 -o rfc.html
        cat httpx.txt | xargs curl -s -L >> curled.html
        cat curled.html | tok | tr '[:upper:]' '[:lower:]' | sort -u > curled.txt
        cat rfc.html | tok | tr '[:upper:]' '[:lower:]' | sort -u > rfc.txt
        comm -13 rfc.txt curled.txt | sort -u | tee -a words.txt
        rm http.txt

}



jsles(){



        echo "${Yellow}From JS les${NC}"
        echo '\n'
        gau $domain | head -n 1000 | fff -s 200 -s 404 -o out
        grep -roh "\"\/[a-zA-Z0-9_/?=&]*\"" out/ | sed -e 's/^"//' -e 's/"$//' | sort -u | tee -a words.txt



}


wayback(){


        echo "${Yellow}Waybackurls"${NC}
        echo "\n"
        echo $domain | waybackurls | tee -a way.txt
        cat way.txt | unfurl -u keys| tee -a wayback.txt
        cat way.txt |unfurl -u paths|tee -a wayback.txt
        sed 's#/#\n#g' wayback.txt  |sort -u |tee -a waybacks.txt
        rm wayback.txt  



 

	rm way.txt






    }




hakcrawl(){
    echo $domain


        echo "${Yellow} Hakcrawler${NC}"
        echo "\n"
        echo $domain | hakrawler -plain -usewayback -scope yolo | unfurl -u keys  | sort -u | tee -a words.txt
        echo $domain | hakrawler -plain -usewayback -scope yolo | unfurl -u paths | sort -u | tee -a words.txt


 }





#Looping


loopEndpoints() {


        echo "${Yellow}loopEndpoints${NC}"
        echo '\n'
        for i in $(cat $domains);
        do
        gau $i| tee -a gau.txt |  unfurl -u keys | tee -a wordlist.txt ; gau $i | unfurl -u paths|tee -a end.txt; sed 's#/#\n#g' end.txt  | sort -u | tee -a test.txt | sort -u ;rm end.txt  | sed -i -e 's/\.css\|\.png\|\.jpeg\|\.jpg\|\.svg\|\.gif\|\.wolf\|\.bmp//g' test.txt
        done



        rm gau.txt


 }




loopWayback(){


        echo "${Yellow}loopWaybackurls"${NC}
        echo "\n"
        cat $domains | waybackurls | tee way.txt

        cat way.txt | unfurl -u keys| tee -a wayback.txt
        cat way.txt |unfurl -u paths|tee -a wayback.txt
        sed 's#/#\n#g' wayback.txt  |sort -u |tee -a waybacks.txt
        rm wayback.txt   




        rm way.txt


    }






loopcurling() {



        echo "${Yellow}loopCurling${NC}"
        echo '\n'
        cat $domains | httpx -threads 4 -o httpx.txt
        curl https://tools.ietf.org/html/rfc1866 -o rfc.html
        cat httpx.txt | xargs curl -s -L >> curled.html
        cat curled.html | tok | tr '[:upper:]' '[:lower:]' | sort -u > curled.txt
        cat rfc.html | tok | tr '[:upper:]' '[:lower:]' | sort -u > rfc.txt
        comm -13 rfc.txt curled.txt | sort -u | tee -a words.txt

}

loopHarkcrawl(){



        echo "${Yellow}loopHakcrawler${NC}"
        echo "\n"
        cat httpx.txt | hakrawler -plain -usewayback -scope yolo | unfurl -u keys  | sort -u  | tee -a words.txt
        cat httpx.txt | hakrawler -plain -usewayback -scope yolo | unfurl -u paths| sort -u  |tee -a words.txt
        rm httpx.txt

 }




loopSorting() {


        echo "${Yellow}Loop Sorintg${NC} "
        echo "\n"
        mkdir endpoint
        sort -u  words.txt sorted.txt wordlist.txt test.txt waybacks.txt > endpoint/sort.txt
        cat endpoint/sort.txt | grep -iv '.css$\|.png$\|.jpeg$\|.jpg$\|.svg$\|.gif$\|.woff$\|.woff2$\|.bmp$\|.mp4$\|.mp3$\|.js$' | tee -a endpoint/wordlists.txt

        rm words.txt endpoint/sort.txt wordlist.txt test.txt waybacks.txt




	#checking if starting word is '/' or not
	for i in $(cat endpoint/wordlists.txt);do
	    starting=$(echo $i | awk '{print substr ($0,0,1)}' )
	    if [ $starting = '/' ];then
		echo $i >> do.txt
	    else
		echo '/'$i >> do.txt
	    fi

	done

	#checking if ending word is '/' or not

	for i in $(cat do.txt);do
	    end=$(echo $i | awk '{print substr ($0,length,1)}' )
	    if [ $end = '/' ];then
		echo $i | rev | cut -c 2-  |rev   >> endpoint/wordlist.txt
	    else
		echo $i >> endpoint/wordlist.txt
	    fi

	done

    rm endpoint/wordlists.txt
    sort -u endpoint/wordlist.txt > endpoint/wordlists.txt
    rm endpoint/wordlist.txt


	


}


singleSorting() {


        echo "${Yellow}Single Sorintg${NC} "
        echo "\n"
        mkdir endpoint
        sort -u words.txt wordlist.txt waybacks.txt   > endpoint/sorted.txt
        cat endpoint/sorted.txt | grep -iv '.css$\|.png$\|.jpeg$\|.jpg$\|.svg$\|.gif$\|.woff$\|.woff2$\|.bmp$\|.mp4$\|.mp3$\|.js$'  | tee -a endpoint/wordlists.txt

        rm words.txt  wordlist.txt waybacks.txt endpoint/sorted.txt






	#checking if starting word is '/' or not
	for i in $(cat endpoint/wordlists.txt);do
	    starting=$(echo $i | awk '{print substr ($0,0,1)}' )
	    if [ $starting = '/' ];then
		echo $i >> do.txt
	    else
		echo '/'$i >> do.txt
	    fi

	done

	#checking if ending word is '/' or not

	for i in $(cat do.txt);do
	    end=$(echo $i | awk '{print substr ($0,length,1)}' )
	    if [ $end = '/' ];then
		echo $i | rev | cut -c 2-  |rev   >> endpoint/wordlist.txt
	    else
		echo $i >> endpoint/wordlist.txt
	    fi

	done



    rm endpoint/wordlists.txt
    sort -u endpoint/wordlist.txt > endpoint/wordlists.txt
    rm endpoint/wordlist.txt

}








bold=$(tput bold)



sigleMain() {


        echo 'Single starts'
        cc=$(echo $domain | wc -l)
        if [ $cc -eq 1 ] && [ $domain != ''  ]
        then
        #single
            hakcrawl
            Endpoints
            jsles
            curling
            wayback


        #sorting
            singleSorting

        else
            echo  "${Cyan}Invalid"
         fi



}

loopMain(){

         echo "${Yellow}Looping starts\n${NC}"
         cc=$(cat $domains | wc | awk '{ print $1}')
         if [ $cc -gt 0 ]
         then

            #loop
            loopcurling
            loopHarkcrawl
            loopEndpoints
            loopWayback


            #sorting
            loopSorting
         else
           echo  "${Cyan}Invalid or File is Empty"
         fi


}





while [ -n "$1" ]; do
case "$1" in
        -d|--domain)
                domain=$2
                sigleMain
                shift;;

        -dd|--domains)
                domains=$2
                if [ -z "$2"  ];then
                    echo "${Yellow}Invalid${NC}"
                else
                loopMain

                fi
                shift;;

        -f|--file)
                file=$2
                urlsFile
                shift;;        

        -h|--help)
                help=$2
                Usage
                shift;;

        *)
                echo  "${Cyan}[-] Unknown Option:${NC}${Purple} $1";
                Usage;;

        esac
        shift
done


if [ "$domains" = '' ] && [ "$domain" = ''  ] && [ "$file" = ''  ]; then

    	echo "${Yellow}  Either give -d/--domain name only or -dd/--domains text file"
    	Usage

fi


