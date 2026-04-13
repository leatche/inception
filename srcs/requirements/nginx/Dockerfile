# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tcherepoff <tcherepoff@student.42.fr>      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/04/09 14:26:35 by tcherepoff        #+#    #+#              #
#    Updated: 2026/04/09 14:26:36 by tcherepoff       ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

RUN rm -f /etc/nginx/sites-enabled/default

COPY tools/nginx.sh /usr/local/bin/nginx.sh
RUN chmod +x /usr/local/bin/nginx.sh

EXPOSE 443

ENTRYPOINT ["nginx.sh"]
