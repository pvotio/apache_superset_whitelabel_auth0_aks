import os
import requests
import logging
from flask import redirect, request
from flask_appbuilder.security.decorators import has_access
from superset.views.base import BaseSupersetView
from flask_appbuilder import expose

logger = logging.getLogger(__name__)

SERVICE_URL = os.environ.get("REPORTING_SERVICE_URL")
TOKEN = os.environ.get("REPORTING_SERVICE_TOKEN")


class ReportingServiceView(BaseSupersetView):

    route_base = "/reports"

    @has_access
    @expose("/generate")
    def redirect_to_reporting(self):
        headers = {"Authorization": f"Token {TOKEN}"}
        data = dict(request.args)
        report_id = data.pop("report_id")
        report_url = f"{SERVICE_URL}/api/reports/{report_id}/"
        logger.info(f"redirect_to_reporting: report_id={report_id}, report_url={report_url}")
        r = requests.request("POST", report_url, headers=headers, data=data)
        if r.status_code != 200 or "hash_id" not in r.json():
            logger.error(f"Error with status code {r.status_code}: {r.text}")
            return "An error occurred while generating the report.", 500

        hash_id = r.json()["hash_id"]
        redirect_url = f"{SERVICE_URL}/reports/result/{hash_id}"
        return redirect(redirect_url, code=302)
