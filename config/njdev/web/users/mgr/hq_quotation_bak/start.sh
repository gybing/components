./stop.sh
cp=./bin
for file in ./lib/*.jar
do
   cp=$cp:$file
done
nohup java -Djava.rmi.server.hostname=172.18.11.21 -Xms256m -Xmx512m -classpath $cp -Djava.security.policy=ServerShell.policy gnnt.MEBS.quotation.QuotationShell QuotationServerShell >>./logs/sys.log & 
