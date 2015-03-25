# Globosat 
# Java 7 e JBoss jboss-as-7.1.1.Final

FROM dockerfile/java:oracle-java7

MAINTAINER InfraTI Operacoes <InfraTIOperacoes@globosat.com.br>

# Cria o usuário jboss
RUN addgroup -q -gid 5000 jboss && adduser --quiet --disabled-password --uid 5000 --gid 5000 \
	--home /opt/jboss --shell /bin/bash --gecos "JBoss user" jboss

# run.sh inicia o serviço jboss
ADD run.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run.sh

# O serviço jboss sobe na porta 8080
EXPOSE 8080

WORKDIR /opt/jboss

# A partir desse ponto, tudo será feito pelo usuário jboss
USER jboss

ENV JBOSS_VERSION jboss-as-7.1.1.Final
# http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz

ENV HOME /opt/jboss

ENV JBOSS_HOME $HOME/$JBOSS_VERSION

# Baixa o jboss
RUN cd $HOME && curl http://download.jboss.org/jbossas/7.1/$JBOSS_VERSION/$JBOSS_VERSION.tar.gz | \
        tar zx 

# Cria a pasta para os logs
RUN mkdir -p $HOME/$JBOSS_VERSION/standalone/log

USER root

# Exporta o volume
VOLUME $HOME/$JBOSS_VERSION/standalone/log

CMD /usr/local/bin/run.sh
