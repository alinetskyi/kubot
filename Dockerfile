FROM ruby:2.5.0

ENV APP_HOME=/home/kubot


COPY . $APP_HOME

RUN groupadd -r app --gid=1000 \
&& useradd -r -m -g app -d $APP_HOME --uid=1000 app \
&& apt-get update \
&& apt-get install -y sqlite3


WORKDIR $APP_HOME

COPY Gemfile Gemfile.lock $APP_HOME/
RUN chown -R app:app $APP_HOME

RUN su app -s /bin/bash -c "bundle install"


RUN chown -R app:app $APP_HOME

USER app

ENV RACK_ENV=production

EXPOSE 4567

ENTRYPOINT ["bin/kubot","start"]
