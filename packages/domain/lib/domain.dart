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
export 'src/auth/repositories/registration_repository.dart';
export 'src/auth/usecases/register_user_usecase.dart';
export 'src/auth/usecases/send_otp_usecase.dart';
export 'src/auth/usecases/get_security_questions_usecase.dart';
export 'src/auth/usecases/register_and_send_otp_usecase.dart';
