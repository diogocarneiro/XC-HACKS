# Variables
# Use 0 or 1 for ONDEMAND
# If you want to filter the channels build your own mysql select
# Example for channels with H265 in the name just add WHERE stream_display_name LIKE '%H265%'

SERVERID=
ONDEMAND=     
DOMAIN=
DBHOST=
DBPORT=
DBNAME=
DBUSER=
DBPASS=

mariadb -N -h $DBHOST -P $DBPORT $DBNAME -e "SELECT id FROM xtream_iptvpro.streams WHERE type=1;" -u $DBUSER -p$DBPASS | while read id; do

mariadb -N -h $DBHOST -P $DBPORT $DBNAME -e "UPDATE xtream_iptvpro.streams_sys SET server_id=$SERVERID WHERE stream_id=$id;" -u $DBUSER -p$DBPASS

mariadb -N -h $DBHOST -P $DBPORT $DBNAME -e "UPDATE xtream_iptvpro.streams_sys SET on_demand=$ONDEMAND WHERE stream_id=$id;" -u $DBUSER -p$DBPASS

curl "http://$DOMAIN/api.php?action=stream&sub=stop&stream_ids[]=$id" && curl "http://$DOMAIN/api.php?action=stream&sub=start&stream_ids[]=$id"

done

