# Fritz!Box Upnp statistics exporter for prometheus

This exporter exports some variables from an 
[AVM Fritzbox](http://avm.de/produkte/fritzbox/)
to prometheus.

This exporter is tested with a Fritzbox 7590 software version 07.12, 07.20 and 07.21.

The goal of the fork is:
  - [x] allow passing of username / password using evironment variable
  - [x] use https instead of http for communitcation with fritz.box
  - [x] move config of metrics to be exported to config file rather then code
  - [x] add config for additional metrics to collect (especially from TR-064 API)
  - [x] create a grafana dashboard consuming the additional metrics
  - [x] collect metrics from lua APIs not available in UPNP APIs
 
Other changes:
  - replaced digest authentication code with own implementation
  - improved error messages
  - **New:** test mode prints details about all SOAP Actions and their parameters
  - **New:** collect option to directly test collection of results
  - **New:** additional metrics to collect details about connected hosts and DECT devices
  - **New:** support to use results like hostname or MAC address as labels to metrics
  - **New:** support for metrics from lua APIs (e.g. CPU temperature, utilization, ...)
 

## Building

    go get github.com/sberk42/fritzbox_exporter/
    cd $GOPATH/src/github.com/sberk42/fritzbox_exporter
    go install

## Running

In the configuration of the Fritzbox the option "Statusinformationen über UPnP übertragen" in the dialog "Heimnetz >
Heimnetzübersicht > Netzwerkeinstellungen" has to be enabled.

Usage:

    $GOPATH/bin/fritzbox_exporter -h
    Usage of ./fritzbox_exporter:
      -gateway-url string
        The URL of the FRITZ!Box (default "http://fritz.box:49000")
      -listen-address string
        The address to listen on for HTTP requests. (default "127.0.0.1:9042")
      -metrics-file string
        The JSON file with the metric definitions. (default "metrics.json")
      -password string
        The password for the FRITZ!Box UPnP service
      -test
        print all available SOAP calls and their results (if call possible) to stdout
      -testLua
        read luaTest.json file make all contained calls and dump results
      -collect
        collect metrics once print to stdout and exit
      -json-out string
        store metrics also to JSON file when running test   
      -username string
        The user for the FRITZ!Box UPnP service
    
    The password (needed for metrics from TR-064 API) can be passed over environment variables to test in shell:
    read -rs PASSWORD && export PASSWORD && ./fritzbox_exporter -username <user> -test; unset PASSWORD

### Using the docker image

The image is configured using environment variables:

* `GATEWAYURL`
* `USER` 
* `LISTEN_ADDRESS` 
* `PASSWORD`

```
$ docker build -t fritzbox_exporter .
$ docker run -e GATEWAYURL="https://fritz.box:49000" -p9133:9133 fritzbox_exporter
```

## Exported metrics

start exporter and run
curl -s http://127.0.0.1:9042/metrics 

## Output of -test

The exporter prints all available Variables to stdout when called with the -test option.
These values are determined by parsing all services from http://fritz.box:49000/igddesc.xml and http://fritzbox:49000/tr64desc.xml (for TR64 username and password is needed!!!)

## Customizing metrics

The metrics to collect are no longer hard coded, but have been moved to the [metrics.json](metrics.json) file, so just adjust to your needs.
For a list of all the available metrics just execute the exporter with -test (username and password are needed for the TR-064 API!)

For a list of all available metrics, see the dumps below (the format is the same as in the metrics.json file, so it can be used to easily add further metrics to retrieve):
- [FritzBox 7590 v7.12](all_available_metrics_7590_7.12.json)
- [FritzBox 7590 v7.20](all_available_metrics_7590_7.20.json)

## Grafana Dashboard

The dashboard is now also published on [Grafana](https://grafana.com/grafana/dashboards/12579).
