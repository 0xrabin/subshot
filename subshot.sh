


if [[ $# -eq 0 ]] ; then
    echo 'Usage bash subshot.sh example.com'
    exit 1
fi


mkdir "$1"_visual && cd "$1"_visual
#echo -n "Running Sublist3r\n"
python3 /opt/tools/Sublist3r/sublist3r.py -d $1 -t 20 -v -o subs.txt
#echo -n "Completed running Sublist3r\nRunning assetfinder\n"
assetfinder --subs-only $1 --threads 20 >> subs.txt
#echo -n "Completed running assetfinder\nRunning amass\n"
amass enum -d $1 -passive | tee -a subs.txt
#echo -n "Completed running amass\nRunning subfinder\n"
subfinder -silent -d $1 >> subs.txt 
curl -s "https://api.hackertarget.com/hostsearch/?q=$1" | awk -F, '{ print $1 }' >> subs.txt
#echo -n "Completed running subfinder\nChecking live hosts and taking screenshots\n"
cat subs.txt | sort -u -o subs.txt
cat subs.txt | httprobe | tee live.txt | aquatone
cd ..
notify-send "Subfinding Completed"
firefox "$1"_visual/aquatone_report.html


