/*
Automatically install content pack for alerts / notification on graylog using the graylog API.

For the module to function a plaintext version of the graylog root_password_sha2 needs to be added using edit secrets.

Note: This will only install on graylog versions >=4.3.5 because of a bug on older versions.
  Link to issue: https://github.com/Graylog2/graylog-plugin-integrations/issues/1113
*/
class cnaas::graylog_content_import(
  $install_content_parameters = '{\"parameters\":{},\"comment\":\"Installed\ using\ puppet\ module\"}', 
  $pass = lookup(["GRAYLOG_ADMIN_PASSWORD"]),
  $content_pack,
  $revision,
  $content_pack_json = loadjson("/etc/puppet/modules/cnaas/files/graylog_content_import/${content_pack}.json"),
  $content_pack_id = $content_pack_json['id'],
  $installation_id = loadjson("/etc/puppet/modules/cnaas/files/graylog_content_import/installation_response.json")['installations'][0]['_id'],
  $installed_revision = loadjson("/etc/puppet/modules/cnaas/files/graylog_content_import/installation_response.json")['installations'][0]['content_pack_revision']
  )
{
  exec {"Make bash script executable":
    command=> "chmod +x /etc/puppet/modules/cnaas/files/graylog_content_import/graylog_content_update"}

  exec {"Updated Content pack if needed":
    command => "/etc/puppet/modules/cnaas/files/graylog_content_import/graylog_content_update ${pass} ${content_pack} ${content_pack_id} ${revision} ${installation_id} ${installed_revision} ${install_content_parameters}"
  }

  exec {"Check installed version of graylog content pack":
    command => "curl -u admin:${pass} -H 'Content-Type: application/json' -H 'X-Requested-By: cli' -X GET 'http://localhost:80/api/system/content_packs/${content_pack_id}/installations' -o /etc/puppet/modules/cnaas/files/graylog_content_import/installation_response.json"
  }
}
