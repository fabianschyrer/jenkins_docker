import com.cloudbees.plugins.credentials.impl.*;
import com.cloudbees.plugins.credentials.*;
import com.cloudbees.plugins.credentials.domains.*;

String keyfile = "/tmp/key"

Credentials c = (Credentials) new UsernamePasswordCredentialsImpl(CredentialsScope.GLOBAL,"<USERNAME>", "DSL seeding for ETL job", "<PROJECT>", "<PASSWORD>")
SystemCredentialsProvider.getInstance().getStore().addCredentials(Domain.global(), c)