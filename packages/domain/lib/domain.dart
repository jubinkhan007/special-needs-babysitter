/// Domain layer exports
library domain;

// Core entities
export 'src/entities/user_role.dart';
export 'src/entities/auth_session.dart';
export 'src/entities/user.dart';

// Core repositories
export 'src/repositories/auth_repository.dart';
export 'src/repositories/profile_repository.dart';

// Core usecases
export 'src/usecases/usecase.dart';
export 'src/usecases/sign_in_usecase.dart';
export 'src/usecases/sign_up_usecase.dart';
export 'src/usecases/sign_out_usecase.dart';

// Auth feature (registration)
export 'src/auth/entities/registration_payload.dart';
export 'src/auth/entities/registered_user.dart';
export 'src/auth/entities/otp_send_payload.dart';
export 'src/auth/entities/otp_verify_payload.dart';
export 'src/auth/repositories/registration_repository.dart';
export 'src/auth/usecases/register_user_usecase.dart';
export 'src/auth/usecases/send_otp_usecase.dart';
export 'src/auth/usecases/get_security_questions_usecase.dart';
export 'src/auth/usecases/register_and_send_otp_usecase.dart';
export 'src/auth/usecases/verify_otp_usecase.dart';

// Parent Profile
// Parent Profile
export 'src/parent_profile/repositories/parent_profile_repository.dart';

// Account Feature
export 'src/account/entities/account_overview.dart';
export 'src/account/repositories/account_repository.dart';
export 'src/account/usecases/get_account_overview_usecase.dart';

// Profile Details Feature
export 'src/profile_details/entities/child.dart';
export 'src/profile_details/entities/emergency_contact.dart';
export 'src/profile_details/entities/care_approach.dart';
export 'src/profile_details/entities/insurance_plan.dart';
export 'src/profile_details/entities/user_profile_details.dart';
export 'src/profile_details/repositories/profile_details_repository.dart';
export 'src/profile_details/usecases/get_profile_details_usecase.dart';

// Jobs Feature
export 'src/jobs/entities/job.dart';
export 'src/jobs/repositories/job_repository.dart';
export 'src/jobs/usecases/create_job_usecase.dart';
export 'src/jobs/usecases/save_local_draft_usecase.dart';
export 'src/jobs/usecases/get_local_draft_usecase.dart';
export 'src/jobs/usecases/clear_local_draft_usecase.dart';
export 'src/jobs/usecases/update_job_usecase.dart';

// Sitter Profile
export 'src/sitter_profile/repositories/sitter_profile_repository.dart';
