FROM registry.access.redhat.com/ubi9/python-39:1-197.1725907694

ARG release=main
ARG version=latest

LABEL com.redhat.component jira-unfurl-bot
LABEL description "Slack bot that unfurls Jira issues shared in Slack channels"
LABEL summary "Slack bot that unfurls Jira issues shared in Slack channels"
LABEL io.k8s.description "Slack bot that unfurls Jira issues shared in Slack channels"
LABEL distribution-scope public
LABEL name jira-unfurl-bot
LABEL release ${release}
LABEL version ${version}
LABEL url https://github.com/openshift-assisted/jira-unfurl-bot
LABEL vendor "Red Hat, Inc."
LABEL maintainer "Red Hat"

# License
USER 0
RUN mkdir /licenses/ && chown 1001:0 /licenses/
USER 1001
COPY LICENSE /licenses/

COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt pip-licenses && pip-licenses -l -f json --output-file /licenses/licenses.json

COPY . .
CMD [ "python3", "jira-unfurl-bot.py" ]
