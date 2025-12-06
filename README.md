# Ephemeral environments setup

This project is a concept demo and practice of a pipeline setup that allows to quickly create and destroy new environements.

### Useful commands

Anótate estos para futuras prácticas:
	•	docker build -t nombre:tag .
	•	docker run --rm -p HOST:CONTAINER imagen
	•	docker ps → ver contenedores activos
	•	docker stop <container_id> → parar uno si lo lanzaste sin --rm
	•	docker logs <container_id> → ver logs (luego será importante para Cloud Run mentalmente)

Cosas que suelen romper más adelante

Anótalas:
	•	COPY package*.json ./ es tu mejor amigo (caché)
	•	npm install siempre antes de COPY . .
	•	CMD debe ejecutar lo que sepa hacer tu contenedor, no tu sistema local


