class ChangeColumnTypeOfJobInProject < ActiveRecord::Migration[5.1]
  def up
    execute %q{ update projects set new_jobs = 0 where new_jobs = ''}
    execute %q{ update projects set retained_jobs = 0 where retained_jobs = ''}
    execute 'ALTER TABLE projects ALTER COLUMN new_jobs TYPE integer USING (new_jobs::integer)'
    execute 'ALTER TABLE projects ALTER COLUMN retained_jobs TYPE integer USING (retained_jobs::integer)'
  end

  def down
    execute 'ALTER TABLE projects ALTER COLUMN new_jobs TYPE string USING (new_jobs::string)'
    execute 'ALTER TABLE projects ALTER COLUMN retained_jobs TYPE string USING (retained_jobs::string)'
  end
end
