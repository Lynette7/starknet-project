use array::ArrayTrait;
use debug::PrintTrait;

#[derive(Copy, Drop)]
struct User {
    username: felt252,
    address: felt252,
}

#[derive(Copy, Drop)]
struct Jobs {
    title: felt252,
    jobtype: JobType,
    description: felt252,
    skills: felt252,
    compensation: felt252,
}

#[derive(Copy, Drop)]
struct Applications {
    title: felt252,
    username: felt252,
}

#[derive(Copy, Drop)]
enum JobType {
    FullTime: (),
    Contract: (),
    Gig: (),
}

#[derive(Drop)]
struct Database {
    users: Array<User>,
    jobs: Array<Jobs>,
    applications: Array<Applications>,
}

impl JobTypePrintImpl of PrintTrait<JobType> {
    fn print(self: JobType) {
        match self {
            JobType::FullTime(_) => ('Full time').print(),
            JobType::Contract(_) => ('Contract').print(),
            JobType::Gig(_) => ('Gig').print(),
        }
    }
}

trait DatabaseTrait {
    fn createuser(ref self: Database, user: User);
    fn find_user(self: @Database, username: felt252);
    fn createjob(ref self: Database, jobs: Jobs);
    fn view_job(self: @Database, title: felt252);
    fn apply_job(ref self: Database, application: Applications);
    fn registered_user(self: @Database, username: felt252) -> bool;
    fn actual_job(self: @Database, title: felt252) -> bool;
}

impl DatabaseImpl of DatabaseTrait {
    fn createuser(ref self: Database, user: User) {
        self.users.append(user);
    }

    fn find_user(self: @Database, username: felt252) {
    let mut i = 0;

    loop {
        let user: User = *self.users[i];
        if user.username == username {
            'User found!'.print();
            user.username.print();
            user.address.print();
            break;
        }
        i += 1;
    };
    }

    fn createjob(ref self: Database, jobs: Jobs) {
        self.jobs.append(jobs);
    }

    fn view_job(self: @Database, title: felt252) {
        let mut i = 0;

        loop {
            let jobs: Jobs = *self.jobs[i];
            if jobs.title == title {
                'Job found!'.print();
                jobs.title.print();
                jobs.jobtype.print();
                jobs.description.print();
                jobs.skills.print();
                jobs.compensation.print();
                break;
            }
            i += 1;
        };
    }

    fn registered_user(self: @Database, username: felt252) -> bool {
        let mut i = 0;
        let mut found: bool = false;

        loop {
            let user: User = *self.users[i];
            if (user.username == username) {
                found = true;
                break;
            }
            i += 1;
        };
        found
    }

    fn actual_job(self: @Database, title: felt252) -> bool {
        let mut i = 0;
        let mut found: bool = false;

        loop {
            let jobs: Jobs = *self.jobs[i];
            if (jobs.title == title) {
                found = true;
                break;
            }
            i += 1;
        };
        found
    }

    fn apply_job(ref self: Database, application: Applications) {
        let user_found = self.registered_user(application.username);
        let job_found = self.actual_job(application.title);
        if (user_found && job_found) {
            self.applications.append(application);
            'Application submitted!'.print();
        } else {
            'User or Job not found'.print();
        }
    }
}

fn main() {
    let user = User {
        username: 'Best dev',
        address: '0x1234567891012345',
    };
    let user2 = User {
        username: 'dev',
        address: '0x1233567891012345',
    };

    let job1 = Jobs {
        title: 'Development',
        jobtype: JobType::Contract(()),
        description: 'A very great job to do',
        skills: 'Python',
        compensation: '200USD',
    };

    let application1 = Applications {
        title: 'Development',
        username: 'dev',
    };

    let mut database = Database {
        users: ArrayTrait::new(),
        jobs: ArrayTrait::new(),
        applications: ArrayTrait::new(),
    };

    database.createuser(user);
    database.createuser(user2);
    database.createjob(job1);
    database.find_user('dev');
    database.view_job('Development');
    database.users.len().print();
    database.apply_job(application1);
}
