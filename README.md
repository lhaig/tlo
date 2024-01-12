# Turn On the Light with Nomad Demo.

This demo showcases Nomads ability to run diverse workloads on a cluster. Specifically it uses the docker and exec task drivers.

## Hardware
* [Turing Pi V1](https://turingpi.com/) with 7 [Raspberry Pi CM3+](https://www.raspberrypi.com/products/compute-module-3-plus/) 8GB modules running Debian.  
* [Shelly Bulb RGB](https://www.shelly.com/en-de/products/product-overview/shelly-duo-rgbw)

## Software
* [Nomad 1.7.2](https://releases.hashicorp.com/nomad/)
* [Demo Magic](https://github.com/paxtonhare/demo-magic/tree/master)

## Setup

Clone the repo
```
git clone git@github.com:lhaig/tlo.git
```

```
cd tlo
```

### Install Nomad
[Install Nomad](https://developer.hashicorp.com/nomad/tutorials/cluster-setup) onto your cluster. 

Deploy the Nomad jobs in this order

1. nomad job run jobs/traefik.nomad.hcl
2. nomad job run jobs/prometheus-server.nomad.hcl
3. nomad job run jobs/prometheus-node-exporter.nomad.hcl 
4. nomad job run jobs/grafana-server.nomad.hcl
5. nomad job run jobs/godad.nomad.hcl

### Install your RGB Light

Install your light and make note of the ipaddress for you light.

### Run the demo jobs
export the address of your Nomad server
`export NOMAD_ADDR=IPADDRESS:4646`

Check the status of your connection to Nomad
```bash
nomad server members
nomad node status
nomad job status"

```
Run the light.nomad.hcl job file replace `IPADDRESSOFLIGHT` with your light ip
```bash
nomad job run -var="url=IPADDRESSOFLIGHT" -var="turn=on" jobs/light.nomad.hcl
```
This should turn the light on.

Have fun 
