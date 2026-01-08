# Ephemeral environments setup

This project is a concept demo and practice of a pipeline setup that allows to quickly create and destroy new environements. 

### Useful commands

Docker:
	•	docker build -t nombre:tag .
	•	docker run --rm -p HOST:CONTAINER imagen
	•	docker ps → ver contenedores activos
	•	docker stop <container_id> → parar uno si lo lanzaste sin --rm
	•	docker logs <container_id> → ver logs (luego será importante para Cloud Run mentalmente)

Google cloud:
	gcloud run services list
	gcloud config set project <PROJECT_ID>
	gcloud config get-value project
	gcloud run deploy
	gcloud run services delete
	gcloud run services logs read

	Ejemplos reales:
		gcloud config set project devops-playground-480421
	y para volver a Mediala:
		gcloud config set project mediala-tech-platform


Cosas que suelen romper más adelante

Anótalas:
	•	COPY package*.json ./ es tu mejor amigo (caché)
	•	npm install siempre antes de COPY . .
	•	CMD debe ejecutar lo que sepa hacer tu contenedor, no tu sistema local


# Set default Google Cloud project:



# En prod

Las llamadas requiere authentication:

curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" \
  "https://directory-563622924666.europe-southwest1.run.app/health"

and 

curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" \
  "https://directory-563622924666.europe-southwest1.run.app/test"  
