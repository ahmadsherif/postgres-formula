{% set postgres = pillar.get('postgres', {}) %}

postgresql-python:
  pkg:
    - installed
    - name: {{ postgres.get('python') }}
