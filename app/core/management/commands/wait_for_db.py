from django.core.management.base import BaseCommand
from psycopg2 import OperationalError as pgError
from django.db.utils import OperationalError

import time

class Command(BaseCommand):
    def handle(self, *args, **options):
        db_up = False
        while db_up is False:
            try:
                self.check(databases=['default'])
                db_up = True
            except (pgError, OperationalError):
                self.stdout.write('Database unavailable, waiting 1 second...')
                time.sleep()
        self.stdout.write(self.style.SUCCESS('Database available!'))