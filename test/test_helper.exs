Application.load(:duper)

for app <- Application.spec(:duper, :applications) do
  Application.ensure_all_started(app)
end

ExUnit.start()
