default:
	@mix phx.server --no-compile
dev:
	@iex -S mix phx.server
install:
	@mix deps.get
	@(cd apps/web/assets && yarn)
compile:
	@mix clean
	@mix compile
	@(cd apps/web/assets && yarn deploy)
	@(cd apps/web && mix phx.digest)
setup: install compile
test:
	@mix deps.get
	@mix test
routes:
	@mix phx.routes Web.Router
db.create:
	@(cd apps/checkout && mix ecto.create)
db.migrate:
	@(cd apps/checkout && mix ecto.migrate)
db.rollback:
	@(cd apps/checkout && mix ecto.rollback)
db.drop:
	@(cd apps/checkout && mix ecto.drop)
db.seed:
	@(cd apps/checkout && mix run priv/repo/seeds.exs)
db.reset: db.drop db.setup
db.setup: db.create db.migrate db.seed
db.migration:
	@(cd apps/domain && mix ecto.gen.migration $(file))
docker.base:
	@docker build -f ./Dockerfile.base -t asia.gcr.io/labs-127/seek:base .
	@docker push asia.gcr.io/labs-127/seek:base
