<div class="copyright" >
  {% set current = date(Date.now(), "YYYY") %}                
  &copy; {% if theme.since and theme.since != current %} <i> {{ theme.since }} - <\i> {% endif %}
  <span itemprop="copyrightYear"><i>{{ current }}</i></span>
  <span class="with-love"> <i class="fa fa-{{ theme.authoricon }}"> </i> </span>
  <span class="author" itemprop="copyrightHolder"> <i>Powered By - {{ config.author }} </i> </span>
</div>

{% if theme.copyright %}
<div class="copyright">
  <i>Contact Me&nbsp&nbsp&nbsp|&nbsp&nbsp&nbsp</i>
  <i><a target="_blank" rel="external" href="https://github.com/timior">https://github.com/timior</a></i>
</div>
{% endif %}