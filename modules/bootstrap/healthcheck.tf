/*data "healthchecksio_channel" "discord" {
  kind = "discord"
}

resource "healthchecksio_check" "cluster_heartbeat" {
  name = "${var.cluster_name}-heartbeat"
  desc = "Alertmanager heartbeat from cluster: ${var.cluster_name}."

  timeout  = 0           # seconds
  grace    = 300         # seconds
  schedule = "* * * * *" # every minute
  timezone = "UTC"


  channels = [
    data.healthchecksio_channel.discord.id
  ]
}
*/
