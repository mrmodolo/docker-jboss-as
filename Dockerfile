# Globosat 
# Java 7 e JBoss jboss-as-7.1.1.Final

FROM dockerfile/java:oracle-java7

MAINTAINER InfraTI Operacoes <InfraTIOperacoes@globosat.com.br>

# Configura o timezone para America/Sao_Paulo
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes locales
RUN echo "America/Sao_Paulo" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata

# Configura o locale para pt_BR.UTF-8
RUN export LANGUAGE=pt_BR.UTF-8; export LANG=pt_BR.UTF-8; \
	export LC_ALL=pt_BR.UTF-8; locale-gen pt_BR.UTF-8;
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

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
