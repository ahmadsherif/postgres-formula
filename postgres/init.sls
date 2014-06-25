{% set postgres = pillar.get('postgres', {}) %}

postgresql-server:
  pkg:
    - installed
    - name: {{ postgres.get('pkg') }}
  service:
    - running
    - enable: true
    - name: {{ postgres.get('service') }}
    - require:
      - pkg: {{ postgres.get('pkg') }}

