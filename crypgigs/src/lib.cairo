//mod main; 

use starknet::{ContractAddress,get_caller_address,Store,SyscallResult,StorageBaseAddress,storage_read_syscall, storage_write_syscall,
    storage_address_from_base_and_offset,};
use array::ArrayTrait;
use hash::{HashStateTrait,Hash};

#[starknet::interface]
#[derive(Drop,Copy,Serde,Hash)]
    struct Applications {
        title: felt252,
        username: felt252,
    }
// trait DatabaseTrait<T> {
//     fn display_books(self:@T)->Array<felt252>;

//     fn add_book(ref self:T,key:Book);

//     fn search_book(self:@T,key:Book)->felt252;
// }

#[starknet::contract]
mod GigListings {

    use super::Applications;
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        users: LegacyMap::<ContractAddress, felt252>,
        applications: LegacyMap::<felt252, felt252>,
        job: Job,
        //jobs: LegacyMap::<JobType, Job>,
    }

    #[constructor]
    fn constructor(ref self: ContractState, user: ContractAddress, user1: ContractAddress){

        let job1 = Job {
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

        self.job.write(job1);
        self.applications.write(application1.title, application1.username);
    }

    #[derive(Copy, Drop, starknet::Store)]

    struct Job {
        title: felt252,
        jobtype: JobType,
        description: felt252,
        skills: felt252,
        compensation: felt252,
    }

    enum JobType {
        FullTime: (),
        Contract: (),
        Gig: (),
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        JobDetails: JobDetails,
    }

    #[derive(Drop, Copy, starknet::Event)]
    struct JobDetails {
        amount: u128,
        title: felt252,
        jobtype: JobType,
        description: felt252,
        skills: felt252,
        compensation: felt252,
    }

    #[external(v0)]
    #[generate_trait]
    // impl JobTypePrintImpl of PrintTrait<JobType> {
    //     fn print(self: JobType) -> felt252 {
    //         match self {
    //             JobType::FullTime(_) => ('Full time'),
    //             JobType::Contract(_) => ('Contract'),
    //             JobType::Gig(_) => ('Gig'),
    //         }
    //     }
    // }

    #[external(v0)]
    #[generate_trait]
    impl DatabaseImpl of DatabaseTrait {
        fn createuser(ref self: ContractState, user: ContractAddress, user1: ContractAddress) {
            let username = 'dev';
            self.users.write(user, username);
            let username1 = 'Best dev';
            self.users.write(user1, username1);
        }

        // fn find_user(self: @ContractState, username: felt252) {
        // let mut i = 0;

        // loop {
        //     let user: User = *self.users[i];
        //     if *self.users.username == username {
        //         user.address
        //         break;
        //     }
        //     i += 1;
        // };
        // }

        fn createjob(ref self: ContractState, jobs: Job) {
            self.job.write(jobs);
        }

        fn view_job(self: @ContractState, title: felt252) {
            self.job.title.read();
            if self.job.title == title {
                self.emit(Event::JobDetails(JobDetails {amount: self.job.amount.read(), title: self.job.title.read(),
                jobtype: self.job.jobtype.read(), description: self.job.description.read(),skills: self.job.skills.read(),
                compensation: self.job.compensation.read()}));
            }
        }

        fn registered_user(self: @ContractState, address: felt252) -> bool {
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

        fn actual_job(self: @ContractState, title: felt252) -> bool {
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

        fn apply_job(ref self: ContractState, title: felt252, username: felt252) {
            let user_found = self.registered_user(username);
            let job_found = self.actual_job(title);
            if (user_found && job_found) {
                self.applications.write(title, username);
            }
        }
    }

    // fn main() {
    //    

        // database.createuser(user);
        // database.createuser(user2);
        // database.createjob(job1);
        // database.find_user('dev');
        // database.view_job('Development');
        // database.users.len().print();
        // database.apply_job(application1);
//     }
 }