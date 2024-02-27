# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
OperationType.create(label: 'Nouvelle CNI', code: 'new_cni', family: 'cni')
OperationType.create(label: 'RenouvellementCNI', code: 'renew_cni', family: 'cni')
OperationType.create(label: 'Duplicata CNI', code: 'duplicata', family: 'cni')
OperationType.create(label: 'Acte de Naissance', code: 'birth_act', family: 'civil_act')
OperationType.create(label: 'Certificat de Décès', code: 'death_act', family: 'civil_act')
OperationType.create(label: 'Certificat de Mariage', code: 'wedding_act', family: 'civil_act')
OperationType.create(label: 'Redevance informatique', code: 'redevance_ticket', family: 'redevance')
OperationType.create(label: 'Declaration douane', code: 'declaration_ticket', family: 'declaration')

# Access credentials app
Platform.create(name: 'USSD CONTRAVENTION', api_key: 'CMotKn2sqbnjfTdy8BHy', api_secret: 'RzLZ8zTxUQsHMV-6pwPa')
Platform.create(name: 'BACKOFFICE CONTRAVENTION', api_key: '9d82800dde403f5c441bfafd9d4b2687', api_secret: 'd8f3e7c88e6ff07111a062f2a18b9d87')
Platform.create(name: 'APP MOBILE CONTRAVENTION ORANGE GUINEE', api_key: '811cae51cf499472cb', api_secret: '0f0861b88e96e406202650a3e96b6cda')
Platform.create(name: 'USSD REDEVANCE INFORMATIQUE GUINEE', api_key: '9437ffc562c266837361', api_secret: 'e2911719-ece8-492e-9925-c4e616bfeeef')
Platform.create(name: 'USSD DECLARATION INFORMATIQUE GUINEE', api_key: '54c4e9753a9b7d82770e', api_secret: '7a902112-d0e7-435d-99ec-880c806afe58')
Platform.create(name: 'BACKOFFICE REDEVANCE && DECLARATION', api_key: '2f2c2bcc7fce47e7fb9a', api_secret: '1c7a19cefcff9b399628')

Parameter.create(name: "Frais contraventions", value: "100", description: "", slug: "frais-contraventions")


## Creation des services 
Service.create(name: 'MMGG_USSD', token: 'sCyWnGrPut8iAqZMeTxojv3z1lFI9NaK', alias: 'traffic_ticket')
Service.create(name: 'USSD_REDEVANCE_INFORMATIQUE_GUINEE_CONAKRY', token: 'VVNTRF9SRURFVkFOQ0VfSU5GT1JNQVRJUVVFX0dVSU5FRV8yMDIzLzA1LzIy', alias: 'redevance_ticket')
Service.create(name: 'USSD_DECLARATION_INFORMATIQUE_GUINEE_CONAKRY', token: 'VVNTRF9ERUNMQVJBVElPTl9JTkZPUk1BVElRVUVfR1VJTkVFX0NPTkFLUllAMTYtMTAtMjAyMw==', alias: 'declaration_ticket')