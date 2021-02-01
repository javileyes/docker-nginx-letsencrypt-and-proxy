if [ ! -f configure/initial.conf -o ! -f ./configure/ssl.conf ]; then echo “faltan ficheros initial.conf y ssl.conf en carpate configure”; exit; fi

if [[ $( docker container ls -a | grep "nginx-ieseuropa$" ) ]]; then echo "ya existe container nginx-ieseuropa "; exit; fi

echo "empezamos"

docker build -t javileyes/nginx-letsencrypt .

#CONFIGURACIÓN INICIAL
echo "CONFIGURACIÓN NGINX INICIAL"
if [ -f ./conf.d/default.conf ]; then cp ./conf.d/default.conf ./conf.d/default.bak; fi
cat configure/initial.conf> ./conf.d/default.conf

docker-compose up -d

sleep 5
echo "intentando conseguir certificado"
sleep 5

if [[ $( docker container logs nginx-ieseuropa | grep "Congratulations" ) ]] 
  then echo "container con certificado creado con exito"
  else echo "hubo un problema con la certificacion" 
fi


#CAMBIOS EN FICHERO “DEFAULT.CONF”: CONFIGURACIÓN DE SSL
echo "CONFIGURACIÓN DE SSL"
cat configure/ssl.conf>> ./conf.d/default.conf

docker container restart nginx-ieseuropa

sleep 5
if [[ $( docker container ls | grep "nginx-ieseuropa$" ) ]]; then echo "container funcionando correctamente después de cambiar configuración"; fi

#CAMBIOS EN FICHERO “DEFAULT.CONF”:  AMPLIACION DE UN BACKEND
#ESTE CAMBIO, AL IGUAL QUE EL ANTERIOR LO PUEDO HACER CUANDO QUIERA, EN ESTE SCRIPT INICIAL O LUEGO
#AL IR INCLUYENDO NUEVOS SERVIDORES GESTIONADOS POR EL PROXY REVERSE DE NGINX

#sleep 5
#cat configure/springEuropa.conf>>./conf.d/default.conf

#docker container restart nginx-ieseuropa


