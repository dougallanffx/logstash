FROM docker.elastic.co/logstash/logstash:6.5.1

# This command takes 2-5 minutes due to Maven downloading and building.
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-prune
RUN /usr/share/logstash/bin/logstash-plugin install logstash-input-kinesis

RUN sed -i 's|^\(-Xm.1g\)$|#\ \1|' config/jvm.options

RUN { \
      echo '-XX:+UnlockExperimentalVMOptions' ; \
      echo '-XX:+UseCGroupMemoryLimitForHeap' ; \
      echo '-XX:MaxRAMFraction=1' ; \
      echo '-Djruby.compile.invokedynamic=false' ; \
      echo '-Djruby.compile.mode=OFF'; \
      echo '-XX:+TieredCompilation'; \
      echo '-XX:TieredStopAtLevel=1'; \
      echo '-Xverify:none'; \
      echo '-XshowSettings:vm' ; \
    } >> config/jvm.options