#-----------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See LICENSE in the project root for license information.
#-----------------------------------------------------------------------------------------

FROM php:7-cli

# Install xdebug
RUN yes | pecl install xdebug \
	&& echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
	&& echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
	&& echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini

# Install git, process tools, zsh, locales, git-flow vim
RUN apt-get update && apt-get -y install git procps zsh less locales git-flow vim \
	# Clean up
	&& apt-get autoremove -y \
	&& apt-get clean -y \
	&& rm -rf /var/lib/apt/lists/* \
	# Add zh_CN locale support
	&& echo 'zh_CN.UTF-8 UTF-8' >> /etc/locale.gen \
	&& locale-gen

# Set time zone
ENV TZ=Asia/Shanghai

# Install Oh-My-Zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# 将composer设置为国内源
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com
