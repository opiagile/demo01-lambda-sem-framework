# 1 criar arquivos de politicas de segurança
# 2 criar role de segurança na aws
aws iam create-role \
  --role-name lambda-exemplo \
  --assume-role-policy-document file://politicas.json \
  | tee logs/role.log

# 3 criar arquivo com conteudo e zipa-lo
zip function.zip index.js    

# 4 criar a function lambda
aws lambda create-function \
  --function-name hello-cli \
  --zip-file fileb://function.zip \
  --handler index.handler \
  --runtime nodejs12.x \
  --role arn:aws:iam::528797419252:role/lambda-exemplo \
  | tee logs/lambda-create.log

# 5 invoke lambda
aws lambda invoke \
  --function-name hello-cli \
  --log-type Tail \
  logs/lambda-exec.log

# 6 criar arquivo com conteudo e zipa-lo
zip function.zip index.js    

# 7 update lambda
aws lambda update-function-code \
  --zip-file fileb://function.zip \
  --function-name hello-cli \
  --publish \
  | tee logs/lambda-update.log

# 8 invoke lambda novamente!
aws lambda invoke \
  --function-name hello-cli \
  --log-type Tail \
  logs/lambda-exec-update.log

# 9 remover tudo para não ficar perdido na aws
aws lambda delete-function \
  --function-name hello-cli

aws iam delete-role \
  --role-name lambda-exemplo