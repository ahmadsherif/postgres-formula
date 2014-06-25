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
    - watch:
      - file: postgres-conf-overrides
      - file: postgres-conf-additions
      - file: update-pg-hba-conf

postgres-superuser:
  postgres_user.present:
    - name: {{ postgres.get('user') }}
    - superuser: True
    - password: {{ postgres.get('pass') }}
    - require:
      - pkg: {{ postgres.get('pkg') }}

postgres-conf-additions:
  file.append:
    - name: /etc/postgresql/9.3/main/postgresql.conf
    - source: salt://postgres/files/postgresql_conf_additions
    - template: jinja
    - require:
      - pkg: postgresql-server

postgres-conf-overrides:
  file.managed:
    - name: /etc/postgresql/9.3/main/conf.d/overrides.conf
    - makedirs: True
    - source: salt://postgres/files/overrides.conf
    - template: jinja
    - require:
      - pkg: postgresql-server

update-pg-hba-conf:
  file.managed:
    - name: /etc/postgresql/9.3/main/pg_hba.conf
    - source: salt://postgres/files/pg_hba.conf
    - template: jinja
    - require:
      - pkg: postgresql-server
