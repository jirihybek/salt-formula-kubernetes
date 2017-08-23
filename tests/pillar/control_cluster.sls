kubernetes:
  control:
    enabled: True
    hostNetwork: True
    service:
      memcached:
        enabled: True
        cluster: test
        privileged: True
        service: memcached
        role: server
        type: LoadBalancer
        replicas: 3
        kind: Deployment
        apiVersion: extensions/v1beta1
        ports:
        - port: 8774
          name: nova-api
        - port: 8775
          name: nova-metadata
        volume:
          volume_name:
            type: hostPath
            mount: /certs
            path: /etc/certs
        container:
          memcached:
            image: memcached
            tag: 2
            ports:
            - port: 8774
              name: nova-api
            - port: 8775
              name: nova-metadata
            variables:
            - name: HTTP_TLS_CERTIFICATE
              value: /certs/domain.crt
            - name: HTTP_TLS_KEY
              value: /certs/domain.key
            volumes:
            - name: /etc/certs
              type: hostPath
              mount: /certs
              path: /etc/certs

    service_template:
      my_service:
        name: my_service_{{'{{name}}'}}
        enabled: True
        template:
          enabled: True
          cluster: test
          service: my_service_{{'{{name}}'}}
          type: LoadBalancer
          replicas: 3
          kind: Deployment
          apiVersion: extensions/v1beta1
          container:
            my_container:
              image: memcached
              tag: 2
              variables:
              - name: PARAM
                value: "{{'{{param}}'}}"
        services:
          - name: test01
            param: param01
          - name: test02
            param: param02