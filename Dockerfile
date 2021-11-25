FROM maven:3-jdk-8 AS package_step

RUN apt-get update && \
  apt-get install -y curl && \
  apt-get install -y openssl && \
  apt-get install -y libssl-dev && \
  apt-get install -y ca-certificates && \
  apt-get install -y apt-transport-https

RUN curl -fsSL https://deb.nodesource.com/setup_15.x | bash - && \
  apt-get install -y nodejs

# Add SAP root CA to container
RUN curl -ks 'http://aia.pki.co.sap.com/aia/SAP%20Global%20Root%20CA.crt' -o '/usr/share/ca-certificates/SAP_Global_Root_CA.crt' && /usr/sbin/update-ca-certificates
RUN cat /usr/share/ca-certificates/SAP_Global_Root_CA.crt | tee -a /etc/ssl/certs/ca-certificates.crt
RUN curl -ks 'http://aia.pki.co.sap.com/aia/SAPNetCA_G2.crt' -o '/usr/share/ca-certificates/SAPNetCA_G2.crt' && /usr/sbin/update-ca-certificates
RUN cat /usr/share/ca-certificates/SAPNetCA_G2.crt | tee -a /etc/ssl/certs/ca-certificates.crt
RUN curl -ks 'http://aia.pki.co.sap.com/aia/SAP%20Global%20Sub%20CA%2002.crt' -o '/usr/share/ca-certificates/SAP_Global_Sub_CA_02.crt' && /usr/sbin/update-ca-certificates
RUN cat /usr/share/ca-certificates/SAP_Global_Sub_CA_02.crt | tee -a /etc/ssl/certs/ca-certificates.crt
RUN curl -ks 'http://aia.pki.co.sap.com/aia/SAP%20Global%20Sub%20CA%2004.crt' -o '/usr/share/ca-certificates/SAP_Global_Sub_CA_04.crt' && /usr/sbin/update-ca-certificates
RUN cat /usr/share/ca-certificates/SAP_Global_Sub_CA_04.crt | tee -a /etc/ssl/certs/ca-certificates.crt
RUN curl -ks 'http://aia.pki.co.sap.com/aia/SAP%20Global%20Sub%20CA%2005.crt' -o '/usr/share/ca-certificates/SAP_Global_Sub_CA_05.crt' && /usr/sbin/update-ca-certificates
RUN cat /usr/share/ca-certificates/SAP_Global_Sub_CA_05.crt | tee -a /etc/ssl/certs/ca-certificates.crt
RUN curl -ks 'http://aia.pki.co.sap.com/aia/SAP%20Cloud%20Root%20CA.crt' -o '/usr/share/ca-certificates/SAP_Cloud_Root_CA.crt' && /usr/sbin/update-ca-certificates
RUN cat /usr/share/ca-certificates/SAP_Cloud_Root_CA.crt | tee -a /etc/ssl/certs/ca-certificates.crt
RUN curl -ks 'http://aia.pki.co.sap.com/aia/SAPPassportG2.crt' -o '/usr/share/ca-certificates/SAPPassportG2.crt' && /usr/sbin/update-ca-certificates
RUN cat /usr/share/ca-certificates/SAPPassportG2.crt | tee -a /etc/ssl/certs/ca-certificates.crt
RUN curl -ks 'http://aia.pki.co.sap.com/aia/SAP%20SSO%20CA%20G2.crt' -o '/usr/share/ca-certificates/SAP_SSO_CA_G2.crt' && /usr/sbin/update-ca-certificates
RUN cat /usr/share/ca-certificates/SAP_SSO_CA_G2.crt | tee -a /etc/ssl/certs/ca-certificates.crt

RUN keytool -import -noprompt -trustcacerts -alias SAP_Global_Root_CA -file /usr/share/ca-certificates/SAP_Global_Root_CA.crt -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit || true
RUN keytool -import -noprompt -trustcacerts -alias SAPNetCA_G2 -file /usr/share/ca-certificates/SAPNetCA_G2.crt -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit || true
RUN keytool -import -noprompt -trustcacerts -alias SAP_Global_Sub_CA_02 -file /usr/share/ca-certificates/SAP_Global_Sub_CA_02.crt -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit || true
RUN keytool -import -noprompt -trustcacerts -alias SAP_Global_Sub_CA_04 -file /usr/share/ca-certificates/SAP_Global_Sub_CA_04.crt -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit || true
RUN keytool -import -noprompt -trustcacerts -alias SAP_Global_Sub_CA_05 -file /usr/share/ca-certificates/SAP_Global_Sub_CA_05.crt -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit || true
RUN keytool -import -noprompt -trustcacerts -alias SAP_Cloud_Root_CA -file /usr/share/ca-certificates/SAP_Cloud_Root_CA.crt -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit || true
RUN keytool -import -noprompt -trustcacerts -alias SAPPassportG2 -file /usr/share/ca-certificates/SAPPassportG2.crt -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit || true
RUN keytool -import -noprompt -trustcacerts -alias SAP_SSO_CA_G2 -file /usr/share/ca-certificates/SAP_SSO_CA_G2.crt -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit || true

CMD ["mvn"]
