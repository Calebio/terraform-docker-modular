intern_port = 1880
ext_port = {
  nodered = {
    dev  = [1980]
    prod = [1880]
  }
  influxdb = {
    dev  = [8186, 8187]
    prod = [8086]
  }
  grafana = {
    dev  = [9090]
    prod = [9091]
  }
}