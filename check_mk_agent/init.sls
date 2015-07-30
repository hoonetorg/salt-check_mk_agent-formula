# vim: sts=2 ts=2 sw=2 et ai
{% from "check_mk_agent/map.jinja" import check_mk_agent with context %}

check_mk_agent__pkg_check_mk_agent:
  pkg.installed:
    - name: check_mk_agent
{% if check_mk_agent.slsrequires is defined and check_mk_agent.slsrequires %}
    - require:
{% for slsrequire in check_mk_agent.slsrequires %}
      - {{slsrequire}}
{% endfor %}
{% endif %}
    - pkgs: {{check_mk_agent.packages}}


check_mk_agent__file_/etc/xinetd.d/check-mk-agent:
  augeas.change:
    - name: /etc/xinetd.d/check-mk-agent
    - context: /files/etc/xinetd.d/check-mk-agent
    - changes:
      - set service/disable no
{% if 'only_from' in check_mk_agent %}
      - rm service/only_from
      - set service/only_from/value[0] {{check_mk_agent.only_from}}
{% endif %}

xinetd:
  pkg.installed: []
  service.running:
    - require:
      - pkg: check_mk_agent
