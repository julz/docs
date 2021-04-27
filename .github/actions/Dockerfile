FROM squidfunk/mkdocs-material
RUN pip install --no-cache-dir mkdocs-macros-plugin

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]