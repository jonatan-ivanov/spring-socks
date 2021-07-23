all: deploy

deploy:
	ssh production.com 'rm -rf /var/www/html/*'
	scp -r content/* production.com:/var/www/html
