-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 08, 2025 at 12:14 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tecdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add program', 7, 'add_program'),
(26, 'Can change program', 7, 'change_program'),
(27, 'Can delete program', 7, 'delete_program'),
(28, 'Can view program', 7, 'view_program'),
(29, 'Can add appointment', 8, 'add_appointment'),
(30, 'Can change appointment', 8, 'change_appointment'),
(31, 'Can delete appointment', 8, 'delete_appointment'),
(32, 'Can view appointment', 8, 'view_appointment'),
(33, 'Can add FAQ', 9, 'add_faq'),
(34, 'Can change FAQ', 9, 'change_faq'),
(35, 'Can delete FAQ', 9, 'delete_faq'),
(36, 'Can view FAQ', 9, 'view_faq'),
(37, 'Can add exam score', 10, 'add_examscore'),
(38, 'Can change exam score', 10, 'change_examscore'),
(39, 'Can delete exam score', 10, 'delete_examscore'),
(40, 'Can view exam score', 10, 'view_examscore'),
(41, 'Can add exam result', 11, 'add_examresult'),
(42, 'Can change exam result', 11, 'change_examresult'),
(43, 'Can delete exam result', 11, 'delete_examresult'),
(44, 'Can view exam result', 11, 'view_examresult'),
(45, 'Can add test center', 12, 'add_testcenter'),
(46, 'Can change test center', 12, 'change_testcenter'),
(47, 'Can delete test center', 12, 'delete_testcenter'),
(48, 'Can view test center', 12, 'view_testcenter'),
(49, 'Can add test room', 13, 'add_testroom'),
(50, 'Can change test room', 13, 'change_testroom'),
(51, 'Can delete test room', 13, 'delete_testroom'),
(52, 'Can view test room', 13, 'view_testroom'),
(53, 'Can add test session', 14, 'add_testsession'),
(54, 'Can change test session', 14, 'change_testsession'),
(55, 'Can delete test session', 14, 'delete_testsession'),
(56, 'Can view test session', 14, 'view_testsession'),
(57, 'Can add announcement', 15, 'add_announcement'),
(58, 'Can change announcement', 15, 'change_announcement'),
(59, 'Can delete announcement', 15, 'delete_announcement'),
(60, 'Can view announcement', 15, 'view_announcement'),
(61, 'Can add otp verification', 16, 'add_otpverification'),
(62, 'Can change otp verification', 16, 'change_otpverification'),
(63, 'Can delete otp verification', 16, 'delete_otpverification'),
(64, 'Can view otp verification', 16, 'view_otpverification'),
(65, 'Can add notification', 17, 'add_notification'),
(66, 'Can change notification', 17, 'change_notification'),
(67, 'Can delete notification', 17, 'delete_notification'),
(68, 'Can view notification', 17, 'view_notification');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(3, 'pbkdf2_sha256$870000$ZW00G8n0xs64agEjEflA6S$3yT+YO6fP4il6hES8N9Ll+oetJa0H28z32ZoGlZPAJA=', NULL, 0, 'james@gmail.com', 'Lebron', 'james', 'james@gmail.com', 1, 1, '2025-03-11 17:57:49.930888'),
(177, 'pbkdf2_sha256$600000$Muf0Iso1eo1i3uBD3bREsT$QINVIB+XRnjOpFFBxt8NAVZBcfuXHUiPTBN3RMsZQ7I=', NULL, 1, 'faminianochristianjude@gmail.com', 'Christian', 'Faminiano', 'faminianochristianjude@gmail.com', 1, 1, '2025-06-19 11:02:12.324625'),
(178, 'pbkdf2_sha256$600000$Xi52Cn0vMUJl5SahhdJncf$Gh1qVvXkUrM36+Gz7gtEuqwDgB8VytTN47qS4GaUkwE=', NULL, 0, 'meow1@gmail.com', 'Micheal', 'Jordan', 'meow1@gmail.com', 0, 1, '2025-06-19 17:07:30.551855'),
(179, 'pbkdf2_sha256$600000$4KNfaXKDupvOHZou6iPUnC$kTRMunjJjKuUtTxucm96v614DubvLg0yUiDoQfcAx8g=', NULL, 0, 'meow3@gmail.com', 'Michael', 'Jordan', 'meow3@gmail.com', 0, 1, '2025-06-24 17:58:37.475662'),
(180, 'pbkdf2_sha256$600000$wxWYUZaxzG9DJoAjregldb$Zc0yvgMI9PLQyHRfd1D3XnpjCRrkIQZh8+A1rg4pPFM=', NULL, 0, 'meow5@gmail.com', 'Rown', 'Faminiano', 'meow5@gmail.com', 0, 1, '2025-06-24 21:18:59.948641'),
(181, 'pbkdf2_sha256$600000$jGuAOPPR4PoFptxYxAifd4$zsEsViZc7Q6y15FdHO5MkOX4o69xILf+3mgiB8m+9W4=', NULL, 0, 'meow6@gmail.com', 'Nke', 'Faminiano', 'meow6@gmail.com', 0, 1, '2025-06-25 01:27:22.784430'),
(182, 'pbkdf2_sha256$600000$WZGbEmmyYJzkwJ3kKUHhOr$Ur1aJYu2VPK1+Bbz7EVRab1zKvDcftEpTxmMu3jxMCM=', NULL, 1, 'sijey', '', '', 'faminianochristianjude@gmail.com', 1, 1, '2025-06-29 18:19:56.735503'),
(184, 'pbkdf2_sha256$600000$MVoxizdY6oFXDv3Erdrl71$FcQOauN9pAQVa9Q2HOwhVfDMY79CoovfdWlruFFLCwA=', NULL, 0, 'meow2@gmail.com', 'CHRISTIAN', 'FAMINIANO', 'meow2@gmail.com', 0, 1, '2025-07-07 12:02:58.886299'),
(185, 'pbkdf2_sha256$600000$O5cl0qj4Vzzae6rBtgl9ww$fOsSNA80L4wo2r9OafguUE15opjCLo5r0q0JRQWwx9w=', NULL, 0, 'cirvagoprod@gmail.com', 'Michael', 'Jordan', 'cirvagoprod@gmail.com', 0, 1, '2025-07-07 12:14:57.523805');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `base_announcement`
--

CREATE TABLE `base_announcement` (
  `id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `type` varchar(20) NOT NULL,
  `date` date NOT NULL,
  `icon` varchar(50) NOT NULL,
  `author` varchar(100) NOT NULL,
  `link` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `image` varchar(100) DEFAULT NULL,
  `image_url` varchar(1000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_announcement`
--

INSERT INTO `base_announcement` (`id`, `title`, `content`, `type`, `date`, `icon`, `author`, `link`, `is_active`, `created_at`, `updated_at`, `created_by_id`, `image`, `image_url`) VALUES
(2, 'jmans', 'The most common type of arthritis, osteoarthritis involves wear-and-tear damage to a joint\'s cartilage — the hard, slick coating on the ends of bones where they form a joint. Cartilage cushions the ends of the bones and allows nearly frictionless joint motion, but enough damage can result in bone grinding directly on bone, which causes pain and restricted movement. This wear and tear can occur over many years, or it can be hastened by a joint injury or infection.\n\nOsteoarthritis also causes changes in the bones and deterioration of the connective tissues that attach muscle to bone and hold the joint together. If cartilage in a joint is severely damaged, the joint lining may become inflamed and swollen.\n\nRheumatoid arthritis\nIn rheumatoid arthritis, the body\'s immune system attacks the lining of the joint capsule, a tough membrane that encloses all the joint parts. This lining (synovial membrane) becomes inflamed and swollen. The disease process can eventually destroy cartilage and bone within the joint.\n\nRisk factors\nRisk factors for arthritis include:\n\nFamily history. Some types of arthritis run in families, so you may be more likely to develop arthritis if your parents or siblings have the disorder.\nAge. The risk of many types of arthritis — including osteoarthritis, rheumatoid arthritis and gout — increases with age.\nYour sex. Women are more likely than men to develop rheumatoid arthritis, while most of the people who have gout, another type of arthritis, are men.\nPrevious joint injury. People who have injured a joint, perhaps while playing a sport, are more likely to eventually develop arthritis in that joint.\nObesity. Carrying excess pounds puts stress on joints, particularly your knees, hips and spine. People with obesity have a higher risk of developing arthritis.', 'Update', '2025-04-19', 'fas fa-book-open', 'Admin Team', NULL, 1, '2025-04-19 08:24:33.199368', '2025-07-06 19:20:15.175838', 3, '', NULL),
(4, 'TAKE WMSU NAT NOW!!!', 'jashjahs', 'New', '2025-04-20', 'fas fa-bell', 'Admin Team', 'sjhdjhsjhd', 1, '2025-04-20 06:40:07.673622', '2025-07-06 19:20:15.194261', 3, '', 'http://127.0.0.1:8000/media/announcements/cffea92b-8c4f-4ebc-820a-7dc727d39471.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `base_appointment`
--

CREATE TABLE `base_appointment` (
  `id` bigint(20) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(254) NOT NULL,
  `contact_number` varchar(20) NOT NULL,
  `school_name` varchar(255) DEFAULT NULL,
  `college_level` varchar(20) NOT NULL,
  `preferred_date` date NOT NULL,
  `time_slot` varchar(20) NOT NULL,
  `status` varchar(30) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `program_id` bigint(20) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `applicant_type` varchar(50) DEFAULT NULL,
  `birth_day` varchar(2) DEFAULT NULL,
  `birth_month` varchar(2) DEFAULT NULL,
  `birth_year` varchar(4) DEFAULT NULL,
  `citizenship` varchar(50) DEFAULT NULL,
  `college_course` varchar(100) DEFAULT NULL,
  `college_type` varchar(50) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `high_school_code` varchar(50) DEFAULT NULL,
  `home_address` longtext DEFAULT NULL,
  `is_first_time` tinyint(1) DEFAULT NULL,
  `school_address` longtext DEFAULT NULL,
  `school_graduation_date` varchar(50) DEFAULT NULL,
  `times_taken` int(11) DEFAULT NULL,
  `is_submitted` tinyint(1) NOT NULL,
  `test_center_id` bigint(20) DEFAULT NULL,
  `test_room_id` bigint(20) DEFAULT NULL,
  `test_session_id` bigint(20) DEFAULT NULL,
  `assigned_test_time_slot` varchar(20) DEFAULT NULL,
  `is_time_slot_modified` tinyint(1) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `exam_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_appointment`
--

INSERT INTO `base_appointment` (`id`, `full_name`, `email`, `contact_number`, `school_name`, `college_level`, `preferred_date`, `time_slot`, `status`, `created_at`, `updated_at`, `program_id`, `user_id`, `age`, `applicant_type`, `birth_day`, `birth_month`, `birth_year`, `citizenship`, `college_course`, `college_type`, `gender`, `high_school_code`, `home_address`, `is_first_time`, `school_address`, `school_graduation_date`, `times_taken`, `is_submitted`, `test_center_id`, `test_room_id`, `test_session_id`, `assigned_test_time_slot`, `is_time_slot_modified`, `first_name`, `last_name`, `middle_name`, `exam_date`) VALUES
(334, 'FAMINIANO, CHRISTIAN JUDE', 'meow5@gmail.com', '+639708701567', 'ZAMBOANGA CHONG HUA HIGH SCHOOL', '', '2025-07-14', 'morning', 'approved', '2025-07-06 20:49:23.162142', '2025-07-07 14:17:14.098017', 11, 180, 18, 'senior_high_graduate', '19', '12', '2006', 'FILIPINO', '', '', 'male', '', 'CRYSTAL STREET SAN JOSE CAWA-CAWA, BAGBAGUIN, ZAMBOANGA CITY', 1, 'FSD', '2025-07-10', 0, 0, 1, 17, 19, 'morning', 1, 'CHRISTIAN', 'FAMINIANO', 'JUDE', '2025-07-24'),
(335, 'JORDAN, MICHAEL DELA CRUZ', 'cirvagoprod@gmail.com', '09708701567', 'ZAMBOANGA CHONG HUA HIGH SCHOOL', '', '2025-07-14', 'morning', 'approved', '2025-07-07 12:22:51.699648', '2025-07-07 14:31:29.680204', 11, 185, 19, 'senior_high_graduate', '21', '12', '2005', 'FILIPINO', '', '', 'male', '', 'COCO ST, BALIWASAN, ZAMBOANGA CITY', 1, 'ASDF', '2025-04-09', 0, 0, 1, 17, 19, 'morning', 1, 'MICHAEL', 'JORDAN', 'DELA CRUZ', '2025-07-24'),
(337, 'FAMINIANO, CHRISTIAN JUDE', 'meow5@gmail.com', '+639708701567', 'ZAMBOANGA CHONG HUA HIGH SCHOOL', '', '2025-07-16', 'morning', 'approved', '2025-07-07 17:10:27.911548', '2025-07-07 19:37:41.261942', 15, 180, 19, 'senior_high_graduate', '19', '12', '2005', 'FILIPINO', '', '', 'male', '', 'CRYSTAL STREET SAN JOSE CAWA-CAWA, 133913001, 133913', 1, 'ZAMBOANGA CITY, ZAMBOANGA PENINSULA, 7000, PHILIPPINES', '2025-06-18', 0, 0, 1, 17, 19, 'morning', 1, 'CHRISTIAN', 'FAMINIANO', 'JUDE', '2025-07-24'),
(338, 'FAMINIANO, CHRISTIAN JUDE', 'meow5@gmail.com', '+639708701567', 'CLARET SCHOOL OF ZAMBOANGA', '', '2025-07-14', 'morning', 'waiting_for_submission', '2025-07-07 19:32:26.105021', '2025-07-07 20:03:42.479293', 12, 180, 17, 'senior_high_graduate', '19', '12', '2007', 'FILIPINO', '', '', 'male', '', 'CRYSTAL STREET SAN JOSE CAWA-CAWA, 083724014, 083724', 1, 'ZAMBOANGA DEL SUR, ZAMBOANGA PENINSULA, PHILIPPINES', '2025-05-12', 0, 0, NULL, NULL, NULL, NULL, 0, 'CHRISTIAN', 'FAMINIANO', 'JUDE', NULL),
(339, 'LOCSON, ARLIE LUNA', 'cirvagoprod@gmail.com', '09708701567', 'DIMATALING NATIONAL HIGH SCHOOL', '', '2025-07-15', 'morning', 'claimed', '2025-07-07 21:30:49.609088', '2025-07-07 21:51:06.740996', 12, 185, 19, 'senior_high_graduate', '21', '12', '2005', 'FILIPINO', '', '', 'male', '', 'PUROK 5, 098316013, 098316', 1, 'ZAMBOANGA SIBUGAY, ZAMBOANGA PENINSULA, PHILIPPINES', '2025-05-14', 0, 0, 1, 17, 19, 'morning', 1, 'ARLIE', 'LOCSON', 'LUNA', '2025-07-24');

-- --------------------------------------------------------

--
-- Table structure for table `base_examresult`
--

CREATE TABLE `base_examresult` (
  `id` bigint(20) NOT NULL,
  `serial_no` int(11) DEFAULT NULL,
  `app_no` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `school` varchar(255) NOT NULL,
  `exam_type` varchar(50) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `imported_by_id` int(11) DEFAULT NULL,
  `year` varchar(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_examresult`
--

INSERT INTO `base_examresult` (`id`, `serial_no`, `app_no`, `name`, `school`, `exam_type`, `created_at`, `updated_at`, `imported_by_id`, `year`) VALUES
(346, 1, 'CET-2024-001', 'John D. Mendoza', 'University of Manila', 'CET', '2025-07-06 21:55:44.265535', '2025-07-06 21:55:44.265555', 177, '2025'),
(347, 2, 'CET-2024-015', 'Maria Cristina Santos', 'Pamantasan ng Lungsod ng Maynila', 'CET', '2025-07-06 21:55:44.267201', '2025-07-06 21:55:44.267215', 177, '2025'),
(348, 3, 'CET-2024-023', 'Carlos A. Reyes', 'Polytechnic University of the Philippines', 'CET', '2025-07-06 21:55:44.268528', '2025-07-06 21:55:44.268539', 177, '2025'),
(349, 4, 'CET-2024-042', 'Jennifer B. Gonzales', 'University of the East', 'CET', '2025-07-06 21:55:44.269806', '2025-07-06 21:55:44.269818', 177, '2025'),
(350, 5, 'CET-2024-057', 'Michael R. Torres', 'Far Eastern University', 'CET', '2025-07-06 21:55:44.271046', '2025-07-06 21:55:44.271056', 177, '2025'),
(351, 6, 'CET-2024-069', 'Sarah Jane Cruz', 'Ateneo de Manila University', 'CET', '2025-07-06 21:55:44.272293', '2025-07-06 21:55:44.272303', 177, '2025'),
(352, 7, 'CET-2024-078', 'Paolo Miguel Tan', 'De La Salle University', 'CET', '2025-07-06 21:55:44.273395', '2025-07-06 21:55:44.273406', 177, '2025'),
(353, 8, 'CET-2024-084', 'Angelica Marie Ramos', 'University of Santo Tomas', 'CET', '2025-07-06 21:55:44.274478', '2025-07-06 21:55:44.274488', 177, '2025'),
(354, 9, 'CET-2024-091', 'Rafael D. Aquino', 'San Beda University', 'CET', '2025-07-06 21:55:44.275375', '2025-07-06 21:55:44.275385', 177, '2025'),
(355, 10, 'CET-2024-103', 'Diana Rose Fernandez', 'Mapua University', 'CET', '2025-07-06 21:55:44.276803', '2025-07-06 21:55:44.276819', 177, '2025'),
(356, 11, 'CET-2024-118', 'Christian James Lopez', 'National University', 'CET', '2025-07-06 21:55:44.278532', '2025-07-06 21:55:44.278550', 177, '2025'),
(357, 12, 'CET-2024-124', 'Sofia Isabel Garcia', 'University of Asia and the Pacific', 'CET', '2025-07-06 21:55:44.280171', '2025-07-06 21:55:44.280189', 177, '2025'),
(358, 13, 'CET-2024-137', 'Daniel Joseph Pascual', 'Lyceum of the Philippines University', 'CET', '2025-07-06 21:55:44.281522', '2025-07-06 21:55:44.281533', 177, '2025'),
(359, 14, 'CET-2024-145', 'Samantha Nicole Dela Cruz', 'Adamson University', 'CET', '2025-07-06 21:55:44.282582', '2025-07-06 21:55:44.282597', 177, '2025'),
(360, 15, 'CET-2024-156', 'Gabriel Antonio Santos', 'San Sebastian College', 'CET', '2025-07-06 21:55:44.283524', '2025-07-06 21:55:44.283536', 177, '2025'),
(361, 16, 'CET-2024-168', 'Kimberly Joy Villanueva', 'Philippine Normal University', 'CET', '2025-07-06 21:55:44.284587', '2025-07-06 21:55:44.284598', 177, '2025'),
(362, 17, 'CET-2024-177', 'Joshua Emmanuel Bautista', 'Technological University of the Philippines', 'CET', '2025-07-06 21:55:44.285479', '2025-07-06 21:55:44.285491', 177, '2025'),
(363, 18, 'CET-2024-185', 'Jasmine Patricia Diaz', 'Miriam College', 'CET', '2025-07-06 21:55:44.286476', '2025-07-06 21:55:44.286487', 177, '2025'),
(364, 19, 'CET-2024-192', 'Ryan Christopher Martinez', 'Arellano University', 'CET', '2025-07-06 21:55:44.287500', '2025-07-06 21:55:44.287511', 177, '2025'),
(365, 20, 'CET-2024-207', 'Stephanie Grace Ocampo', 'Centro Escolar University', 'CET', '2025-07-06 21:55:44.288456', '2025-07-06 21:55:44.288466', 177, '2025'),
(366, 1, 'CET-2024-001', 'John D. Mendoza', 'University of Manila', 'NAT', '2025-07-07 21:56:25.524613', '2025-07-07 21:56:25.524646', 177, '2025'),
(367, 2, 'CET-2024-015', 'Maria Cristina Santos', 'Pamantasan ng Lungsod ng Maynila', 'NAT', '2025-07-07 21:56:25.527140', '2025-07-07 21:56:25.527158', 177, '2025'),
(368, 3, 'CET-2024-023', 'Carlos A. Reyes', 'Polytechnic University of the Philippines', 'NAT', '2025-07-07 21:56:25.528420', '2025-07-07 21:56:25.528434', 177, '2025'),
(369, 4, 'CET-2024-042', 'Jennifer B. Gonzales', 'University of the East', 'NAT', '2025-07-07 21:56:25.529458', '2025-07-07 21:56:25.529471', 177, '2025'),
(370, 5, 'CET-2024-057', 'Michael R. Torres', 'Far Eastern University', 'NAT', '2025-07-07 21:56:25.530521', '2025-07-07 21:56:25.530537', 177, '2025'),
(371, 6, 'CET-2024-069', 'Sarah Jane Cruz', 'Ateneo de Manila University', 'NAT', '2025-07-07 21:56:25.534178', '2025-07-07 21:56:25.534206', 177, '2025'),
(372, 7, 'CET-2024-078', 'Paolo Miguel Tan', 'De La Salle University', 'NAT', '2025-07-07 21:56:25.536262', '2025-07-07 21:56:25.536290', 177, '2025'),
(373, 8, 'CET-2024-084', 'Angelica Marie Ramos', 'University of Santo Tomas', 'NAT', '2025-07-07 21:56:25.544806', '2025-07-07 21:56:25.544825', 177, '2025'),
(374, 9, 'CET-2024-091', 'Rafael D. Aquino', 'San Beda University', 'NAT', '2025-07-07 21:56:25.546296', '2025-07-07 21:56:25.546312', 177, '2025'),
(375, 10, 'CET-2024-103', 'Diana Rose Fernandez', 'Mapua University', 'NAT', '2025-07-07 21:56:25.547742', '2025-07-07 21:56:25.547771', 177, '2025'),
(376, 11, 'CET-2024-118', 'Christian James Lopez', 'National University', 'NAT', '2025-07-07 21:56:25.549036', '2025-07-07 21:56:25.549054', 177, '2025'),
(377, 12, 'CET-2024-124', 'Sofia Isabel Garcia', 'University of Asia and the Pacific', 'NAT', '2025-07-07 21:56:25.550775', '2025-07-07 21:56:25.550839', 177, '2025'),
(378, 13, 'CET-2024-137', 'Daniel Joseph Pascual', 'Lyceum of the Philippines University', 'NAT', '2025-07-07 21:56:25.552903', '2025-07-07 21:56:25.552922', 177, '2025'),
(379, 14, 'CET-2024-145', 'Samantha Nicole Dela Cruz', 'Adamson University', 'NAT', '2025-07-07 21:56:25.554899', '2025-07-07 21:56:25.554916', 177, '2025'),
(380, 15, 'CET-2024-156', 'Gabriel Antonio Santos', 'San Sebastian College', 'NAT', '2025-07-07 21:56:25.556598', '2025-07-07 21:56:25.556619', 177, '2025'),
(381, 16, 'CET-2024-168', 'Kimberly Joy Villanueva', 'Philippine Normal University', 'NAT', '2025-07-07 21:56:25.558114', '2025-07-07 21:56:25.558129', 177, '2025'),
(382, 17, 'CET-2024-177', 'Joshua Emmanuel Bautista', 'Technological University of the Philippines', 'NAT', '2025-07-07 21:56:25.559319', '2025-07-07 21:56:25.559334', 177, '2025'),
(383, 18, 'CET-2024-185', 'Jasmine Patricia Diaz', 'Miriam College', 'NAT', '2025-07-07 21:56:25.560472', '2025-07-07 21:56:25.560484', 177, '2025'),
(384, 19, 'CET-2024-192', 'Ryan Christopher Martinez', 'Arellano University', 'NAT', '2025-07-07 21:56:25.561559', '2025-07-07 21:56:25.561570', 177, '2025'),
(385, 20, 'CET-2024-207', 'Stephanie Grace Ocampo', 'Centro Escolar University', 'NAT', '2025-07-07 21:56:25.562444', '2025-07-07 21:56:25.562456', 177, '2025');

-- --------------------------------------------------------

--
-- Table structure for table `base_examscore`
--

CREATE TABLE `base_examscore` (
  `id` bigint(20) NOT NULL,
  `score` varchar(20) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `appointment_id` bigint(20) DEFAULT NULL,
  `app_no` varchar(50) DEFAULT NULL,
  `exam_type` varchar(50) DEFAULT NULL,
  `imported_by_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `school` varchar(255) DEFAULT NULL,
  `exam_date` date DEFAULT NULL,
  `oapr` varchar(20) DEFAULT NULL,
  `part1` varchar(20) DEFAULT NULL,
  `part2` varchar(20) DEFAULT NULL,
  `part3` varchar(20) DEFAULT NULL,
  `part4` varchar(20) DEFAULT NULL,
  `part5` varchar(20) DEFAULT NULL,
  `year` varchar(4) DEFAULT NULL,
  `program_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_examscore`
--

INSERT INTO `base_examscore` (`id`, `score`, `created_at`, `updated_at`, `appointment_id`, `app_no`, `exam_type`, `imported_by_id`, `name`, `school`, `exam_date`, `oapr`, `part1`, `part2`, `part3`, `part4`, `part5`, `year`, `program_id`) VALUES
(239, '85', '2025-07-07 21:20:03.484507', '2025-07-07 21:20:03.484524', NULL, 'WMSU-2025-001', 'EAT', 177, 'JUAN ANG DELA CRUZ', 'ZNHS', '2025-06-25', '85', '18', '17', '15', '19', '16', '2025', 15),
(240, '73', '2025-07-07 21:20:03.500032', '2025-07-07 21:20:03.500046', NULL, 'WMSU-2025-002', 'EAT', 177, 'MARIA LOCSON SANTOS', 'ST. JOSEPH HIGH SCHOOL', '2025-06-25', '73', '15', '14', '16', '13', '15', '2025', 15),
(241, '99', '2025-07-07 21:20:03.511981', '2025-07-07 21:20:03.511998', NULL, 'WMSU-2025-003', 'EAT', 177, 'MICHAEL DELA CRUZ JORDAN', 'ZAMBOANGA CHONG HUA HIGH SCHOOL', '2025-07-24', '99', '20', '20', '19', '20', '20', '2025', 15),
(242, '64', '2025-07-07 21:20:03.521845', '2025-07-07 21:20:03.521862', NULL, 'WMSU-2025-004', 'EAT', 177, 'CHRISTIAN JUDE JUDE FAMINIANO', 'ZAMBOANGA CHONG HUA HIGH SCHOOL', '2025-07-24', '64', '12', '13', '14', '12', '13', '2025', 15),
(243, '75', '2025-07-07 21:20:03.538408', '2025-07-07 21:20:03.538435', 337, 'WMSU-2025-005', 'EAT', 177, 'CHRISTIAN JUDE FAMINIANO', 'ZAMBOANGA CHONG HUA HIGH SCHOOL', '2025-07-24', '75', '16', '15', '15', '14', '15', '2025', 15);

-- --------------------------------------------------------

--
-- Table structure for table `base_faq`
--

CREATE TABLE `base_faq` (
  `id` bigint(20) NOT NULL,
  `question` longtext NOT NULL,
  `answer` longtext NOT NULL,
  `category` varchar(100) NOT NULL,
  `icon` varchar(50) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `order` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_faq`
--

INSERT INTO `base_faq` (`id`, `question`, `answer`, `category`, `icon`, `is_active`, `order`, `created_at`, `updated_at`) VALUES
(4, 'meowmeow', 'sdjdkjkd', 'General', 'fas fa-question', 1, 0, '2025-04-20 03:57:27.526571', '2025-07-05 14:55:12.010337'),
(5, 'The most Important meow meow', 'sdjdkjkd', 'General', 'fas fa-question', 1, 1, '2025-07-05 13:28:48.429682', '2025-07-05 14:55:12.025144');

-- --------------------------------------------------------

--
-- Table structure for table `base_notification`
--

CREATE TABLE `base_notification` (
  `id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` longtext NOT NULL,
  `type` varchar(20) NOT NULL,
  `priority` varchar(10) NOT NULL,
  `is_read` tinyint(1) NOT NULL,
  `is_global` tinyint(1) NOT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_notification`
--

INSERT INTO `base_notification` (`id`, `title`, `message`, `type`, `priority`, `is_read`, `is_global`, `icon`, `link`, `created_at`, `updated_at`, `created_by_id`, `user_id`) VALUES
(1, 'Test Notification', 'This is a test notification to verify the system is working.', 'appointment', 'normal', 0, 0, 'check-circle', '/profile', '2025-07-06 21:02:12.665767', '2025-07-06 21:02:12.665790', NULL, 3),
(2, 'Application Claimed', 'Your application for College Entrance Test has been marked as claimed. Thank you!', 'appointment', 'normal', 1, 0, 'check', '/profile', '2025-07-06 21:37:52.245113', '2025-07-06 21:37:57.125637', 177, 180),
(3, 'Application Submitted', 'Your application for College Entrance Test has been marked as submitted and is now under review.', 'appointment', 'normal', 1, 0, 'paper-plane', '/profile', '2025-07-06 21:39:01.628173', '2025-07-06 21:39:08.687293', 177, 180),
(4, 'Exam Results Released', 'The results for CET (2025) are now available. You can search for results using your application number on the Exam Passers page.', 'exam', 'high', 1, 1, 'award', '/results', '2025-07-06 21:55:44.289572', '2025-07-06 21:55:56.562375', 177, NULL),
(5, 'Appointment Approved', 'Your appointment for College Entrance Test has been approved. You can now view your test details.', 'appointment', 'normal', 1, 0, 'check-circle', '/profile', '2025-07-06 22:07:09.424213', '2025-07-06 22:09:52.158274', 177, 180),
(6, 'Exam Results Released', 'The results for CET (2025) are now available. 1 scores have been published. You can check your results in the Results section.', 'exam', 'high', 1, 1, 'graduation-cap', '/results', '2025-07-06 22:07:43.290981', '2025-07-06 22:07:54.618940', 177, NULL),
(7, 'Exam Results Released', 'The results for CET (2025) are now available. 1 scores have been published. You can check your results in the Results section.', 'exam', 'high', 1, 1, 'graduation-cap', '/results', '2025-07-06 22:12:57.653735', '2025-07-06 22:13:03.990932', 177, NULL),
(8, 'Exam Scores Released', 'The scores for CET (2025) are now available. 1 scores have been published. You can check your results in the Profile section.', 'exam', 'high', 1, 1, 'graduation-cap', '/profile', '2025-07-06 22:17:07.170750', '2025-07-06 22:17:16.205235', 177, NULL),
(9, 'Exam Scores Released', 'The scores for CET (2025) are now available. 1 scores have been published. You can check your results in the Profile section.', 'exam', 'high', 1, 1, 'graduation-cap', '/profile', '2025-07-06 23:02:42.250827', '2025-07-07 11:33:03.538154', 177, NULL),
(10, 'Application Submitted', 'Your application for College Entrance Test has been marked as submitted and is now under review.', 'appointment', 'normal', 1, 0, 'paper-plane', '/profile', '2025-07-07 12:23:29.919298', '2025-07-07 12:23:29.919313', 177, 185),
(11, 'Appointment Approved', 'Your appointment for College Entrance Test has been approved. You can now view your test details.', 'appointment', 'normal', 1, 0, 'check-circle', '/profile', '2025-07-07 12:25:18.196844', '2025-07-07 12:25:18.196858', 177, 185),
(12, 'Application Submitted', 'Your application for College Entrance Test has been marked as submitted and is now under review.', 'appointment', 'normal', 1, 0, 'paper-plane', '/profile', '2025-07-07 12:47:28.861600', '2025-07-07 12:47:28.861614', 177, 185),
(13, 'Appointment Approved', 'Your appointment for College Entrance Test has been approved. You can now view your test details.', 'appointment', 'normal', 1, 0, 'check-circle', '/profile', '2025-07-07 12:48:17.029174', '2025-07-07 12:48:17.029207', 177, 185),
(14, 'Exam Scores Released', 'The scores for CET (2025) are now available. 2 scores have been published. You can check your results in the Profile section.', 'exam', 'high', 1, 1, 'graduation-cap', '/profile', '2025-07-07 13:32:14.315082', '2025-07-07 13:32:14.315101', 177, NULL),
(15, 'Exam Scores Released', 'The scores for CET (2025) are now available. 2 scores have been published. You can check your results in the Profile section.', 'exam', 'high', 1, 1, 'graduation-cap', '/profile', '2025-07-07 13:35:34.037588', '2025-07-07 13:47:47.110368', 177, NULL),
(16, 'Exam Scores Released', 'The scores for CET (2025) are now available. 2 scores have been published. You can check your results in the Profile section.', 'exam', 'high', 1, 1, 'graduation-cap', '/profile', '2025-07-07 14:15:17.886479', '2025-07-07 14:15:17.886493', 177, NULL),
(17, 'Appointment Approved', 'Your appointment for College Entrance Test has been approved. You can now view your test details.', 'appointment', 'normal', 1, 0, 'check-circle', '/profile', '2025-07-07 14:17:10.637149', '2025-07-07 14:17:10.637164', 177, 180),
(18, 'Appointment Approved', 'Your appointment for College Entrance Test has been approved. You can now view your test details.', 'appointment', 'normal', 1, 0, 'check-circle', '/profile', '2025-07-07 14:17:52.195121', '2025-07-07 14:17:52.195133', 177, 185),
(19, 'Application Claimed', 'Your application for College Entrance Test has been marked as claimed. Thank you!', 'appointment', 'normal', 1, 0, 'check', '/profile', '2025-07-07 14:21:09.105707', '2025-07-07 14:21:09.105720', 177, 185),
(20, 'Appointment Approved', 'Your appointment for College Entrance Test has been approved. You can now view your test details.', 'appointment', 'normal', 1, 0, 'check-circle', '/profile', '2025-07-07 14:24:59.964412', '2025-07-07 14:24:59.964425', 177, 185),
(21, 'Appointment Approved', 'Your appointment for College Entrance Test has been approved. You can now view your test details.', 'appointment', 'normal', 1, 0, 'check-circle', '/profile', '2025-07-07 14:31:26.535657', '2025-07-07 14:31:26.535669', 177, 185),
(22, 'Application Submitted', 'Your application for Engineering Aptitude Test has been marked as submitted and is now under review.', 'appointment', 'normal', 1, 0, 'paper-plane', '/profile', '2025-07-07 17:10:37.397805', '2025-07-07 17:10:37.397821', 177, 180),
(23, 'Ready for Claiming', 'Your results for Engineering Aptitude Test are ready for claiming. Please visit the office to claim your documents.', 'appointment', 'normal', 1, 0, 'hand-paper', '/profile', '2025-07-07 17:15:55.587221', '2025-07-07 17:15:55.587247', 177, 180),
(24, 'Appointment Approved', 'Your appointment for Engineering Aptitude Test has been approved. You can now view your test details.', 'appointment', 'normal', 1, 0, 'check-circle', '/profile', '2025-07-07 17:18:09.781769', '2025-07-07 17:18:09.781785', 177, 180),
(25, 'Appointment Approved', 'Your appointment for Engineering Aptitude Test has been approved. You can now view your test details.', 'appointment', 'normal', 1, 0, 'check-circle', '/profile', '2025-07-07 17:20:35.907575', '2025-07-07 17:20:35.907588', 177, 180),
(26, 'Appointment Rescheduled', 'Your appointment for Engineering Aptitude Test has been rescheduled. Please check your new test details.', 'appointment', 'normal', 1, 0, 'calendar-alt', '/profile', '2025-07-07 17:21:23.042446', '2025-07-07 17:21:23.042460', 177, 180),
(27, 'Appointment Rescheduled', 'Your appointment for Engineering Aptitude Test has been rescheduled. Please check your new test details.', 'appointment', 'normal', 1, 0, 'calendar-alt', '/profile', '2025-07-07 19:18:54.119273', '2025-07-07 19:18:54.119288', 177, 180),
(28, 'Application Submitted', 'Your application for Engineering Aptitude Test has been marked as submitted and is now under review.', 'appointment', 'normal', 1, 0, 'paper-plane', '/profile', '2025-07-07 19:33:28.602799', '2025-07-07 19:33:28.602812', 177, 180),
(29, 'Exam Scores Released', 'The scores for NAT (2025) are now available. 2 scores have been published. You can check your results in the Profile section.', 'exam', 'high', 1, 1, 'graduation-cap', '/profile', '2025-07-07 19:34:37.888132', '2025-07-07 19:34:37.888145', 177, NULL),
(30, 'Exam Scores Released', 'The scores for NAT (2025) are now available. 2 scores have been published. You can check your results in the Profile section.', 'exam', 'high', 1, 1, 'graduation-cap', '/profile', '2025-07-07 19:35:25.425871', '2025-07-07 19:35:25.425883', 177, NULL),
(31, 'Appointment Approved', 'Your appointment for Engineering Aptitude Test has been approved. You can now view your test details.', 'appointment', 'normal', 1, 0, 'check-circle', '/profile', '2025-07-07 19:37:39.530022', '2025-07-07 19:37:39.530037', 177, 180),
(32, 'Exam Scores Released', 'The scores for EAT (2025) are now available. 2 scores have been published. You can check your results in the Profile section.', 'exam', 'high', 1, 1, 'graduation-cap', '/profile', '2025-07-07 19:38:33.029865', '2025-07-07 19:38:33.029878', 177, NULL),
(33, 'Exam Scores Released', 'The scores for EAT (2025) are now available. 2 scores have been published. You can check your results in the Profile section.', 'exam', 'high', 1, 1, 'graduation-cap', '/profile', '2025-07-07 20:10:30.029577', '2025-07-07 20:10:30.029615', 177, NULL),
(34, 'Exam Scores Released', 'The scores for EAT (2025) are now available. 2 scores have been published. You can check your results in the Profile section.', 'exam', 'high', 1, 1, 'graduation-cap', '/profile', '2025-07-07 20:59:43.790669', '2025-07-07 20:59:43.790682', 177, NULL),
(35, 'Exam Scores Released', 'The scores for EAT (2025) are now available. 2 scores have been published. You can check your results in the Profile section.', 'exam', 'high', 1, 1, 'graduation-cap', '/profile', '2025-07-07 21:06:19.273992', '2025-07-07 21:06:19.274006', 177, NULL),
(36, 'Exam Scores Released', 'The scores for EAT (2025) are now available. 2 scores have been published. You can check your results in the Profile section.', 'exam', 'high', 1, 1, 'graduation-cap', '/profile', '2025-07-07 21:13:22.914561', '2025-07-07 21:13:22.914579', 177, NULL),
(37, 'Exam Scores Released', 'The scores for EAT (2025) are now available. 1 scores have been published. You can check your results in the Profile section.', 'exam', 'high', 1, 1, 'graduation-cap', '/profile', '2025-07-07 21:20:03.540074', '2025-07-07 21:20:03.540091', 177, NULL),
(38, 'Application Submitted', 'Your application for Nursing Aptitude Test has been marked as submitted and is now under review.', 'appointment', 'normal', 0, 0, 'paper-plane', '/profile', '2025-07-07 21:32:43.577589', '2025-07-07 21:32:43.577601', 177, 185),
(39, 'Appointment Approved', 'Your appointment for Nursing Aptitude Test has been approved. You can now view your test details.', 'appointment', 'normal', 0, 0, 'check-circle', '/profile', '2025-07-07 21:36:10.808821', '2025-07-07 21:36:10.808835', 177, 185),
(40, 'Application Submitted', 'Your application for Nursing Aptitude Test has been marked as submitted and is now under review.', 'appointment', 'normal', 0, 0, 'paper-plane', '/profile', '2025-07-07 21:42:51.116382', '2025-07-07 21:42:51.116395', 177, 185),
(41, 'Appointment Approved', 'Your appointment for Nursing Aptitude Test has been approved. You can now view your test details.', 'appointment', 'normal', 0, 0, 'check-circle', '/profile', '2025-07-07 21:43:42.567620', '2025-07-07 21:43:42.567643', 177, 185),
(42, 'Application Claimed', 'Your application for Nursing Aptitude Test has been marked as claimed. Thank you!', 'appointment', 'normal', 0, 0, 'check', '/profile', '2025-07-07 21:44:41.786503', '2025-07-07 21:44:41.786532', 177, 185),
(43, 'Application Submitted', 'Your application for Nursing Aptitude Test has been marked as submitted and is now under review.', 'appointment', 'normal', 0, 0, 'paper-plane', '/profile', '2025-07-07 21:46:47.543191', '2025-07-07 21:46:47.543204', 177, 185),
(44, 'Appointment Approved', 'Your appointment for Nursing Aptitude Test has been approved. You can now view your test details.', 'appointment', 'normal', 0, 0, 'check-circle', '/profile', '2025-07-07 21:49:09.444342', '2025-07-07 21:49:09.444363', 177, 185),
(45, 'Application Claimed', 'Your application for Nursing Aptitude Test has been marked as claimed. Thank you!', 'appointment', 'normal', 0, 0, 'check', '/profile', '2025-07-07 21:51:06.744027', '2025-07-07 21:51:06.744040', 177, 185),
(46, 'Exam Results Released', 'The results for NAT (2025) are now available. You can search for results using your application number on the Exam Passers page.', 'exam', 'high', 0, 1, 'award', '/results', '2025-07-07 21:56:25.563474', '2025-07-07 21:56:25.563484', 177, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `base_otpverification`
--

CREATE TABLE `base_otpverification` (
  `id` bigint(20) NOT NULL,
  `email` varchar(254) NOT NULL,
  `otp_code` varchar(6) NOT NULL,
  `is_verified` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `expires_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_otpverification`
--

INSERT INTO `base_otpverification` (`id`, `email`, `otp_code`, `is_verified`, `created_at`, `expires_at`) VALUES
(4, 'kalvinlakuping123@gmail.com', '423664', 0, '2025-05-15 18:52:41.148954', '2025-05-16 03:02:41.132842');

-- --------------------------------------------------------

--
-- Table structure for table `base_program`
--

CREATE TABLE `base_program` (
  `id` bigint(20) NOT NULL,
  `name` varchar(200) NOT NULL,
  `code` varchar(50) NOT NULL,
  `description` longtext NOT NULL,
  `icon` varchar(50) NOT NULL,
  `capacity_limit` int(11) NOT NULL,
  `availability_date` date NOT NULL,
  `requirements` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`requirements`)),
  `status` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `auto_approve_appointments` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_program`
--

INSERT INTO `base_program` (`id`, `name`, `code`, `description`, `icon`, `capacity_limit`, `availability_date`, `requirements`, `status`, `created_at`, `updated_at`, `auto_approve_appointments`) VALUES
(11, 'College Entrance Test', 'CET', 'Launch your college journey with our College Entrance Exam! Designed for high school students, this comprehensive test evaluates your proficiency in mathematics, critical reading, and writing—key skills for academic success. Administered multiple times a year.', 'graduation-cap', 150, '2025-06-20', '[\"School ID\", \"2X2 picture\", \"SHS report card\", \"birth\"]', 'active', '2025-03-09 04:34:40.544229', '2025-06-19 17:28:37.678895', 0),
(12, 'Nursing Aptitude Test', 'NAT', 'The Nursing Aptitude Test is designed to assess the skills, knowledge, and qualities essential for a successful career in nursing. It evaluates critical thinking, problem-solving abilities, communication skills, and basic healthcare knowledge', 'user-nurse', 140, '2025-03-28', '[\"CET RESULT\", \"Report card\", \"2x2 picture\", \"220 pesos\"]', 'active', '2025-03-09 14:49:57.821160', '2025-03-24 07:50:38.831967', 0),
(15, 'Engineering Aptitude Test', 'EAT', 'The Engineering Aptitude Test is a comprehensive assessment designed to evaluate the core skills and knowledge required for a successful career in engineering. It measures logical reasoning, mathematical proficiency, problem-solving abilities, and understanding of fundamental engineering concepts.', 'gears', 2, '2025-06-26', '[\"Report Card\", \"yourself\"]', 'active', '2025-03-10 06:45:02.020804', '2025-06-24 17:57:20.217419', 1),
(23, 'Special Considerations - CET', 'SPECIAL-CET', 'For the International or Special Cases to take an Entrance Exam', 'graduation-cap', 100, '2025-07-03', '[\"2x2 ID Picture\", \"Grades\"]', 'active', '2025-07-03 14:17:55.415980', '2025-07-03 14:17:55.415995', 0);

-- --------------------------------------------------------

--
-- Table structure for table `base_testcenter`
--

CREATE TABLE `base_testcenter` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `code` varchar(20) NOT NULL,
  `address` longtext DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_testcenter`
--

INSERT INTO `base_testcenter` (`id`, `name`, `code`, `address`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'WESTERN MINDANAO STATE UNIVERSITY', 'WMSU', 'BALIWSASAN ROAD', 1, '2025-04-10 15:37:08.530691', '2025-04-10 15:37:08.530691'),
(2, 'PAGADIAN SCIENCE HIGH SCHOOL', '2', 'PAGADIAN', 1, '2025-06-23 22:02:11.038218', '2025-06-23 22:02:11.038218');

-- --------------------------------------------------------

--
-- Table structure for table `base_testroom`
--

CREATE TABLE `base_testroom` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `room_code` varchar(20) NOT NULL,
  `capacity` int(11) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `test_center_id` bigint(20) NOT NULL,
  `assigned_count` int(11) NOT NULL,
  `available_capacity` int(11) NOT NULL,
  `time_slot` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_testroom`
--

INSERT INTO `base_testroom` (`id`, `name`, `room_code`, `capacity`, `is_active`, `test_center_id`, `assigned_count`, `available_capacity`, `time_slot`) VALUES
(17, 'ccs', 'lr3', 30, 1, 1, 6, 24, 'morning'),
(18, 'Room 1', '1', 30, 1, 2, 0, 30, 'morning'),
(19, 'ROOM101 - Morning', 'R101', 30, 1, 1, 0, 30, 'morning'),
(20, 'ROOM101 - Afternoon', 'R101-PM', 30, 1, 1, 0, 30, 'afternoon');

-- --------------------------------------------------------

--
-- Table structure for table `base_testsession`
--

CREATE TABLE `base_testsession` (
  `id` bigint(20) NOT NULL,
  `exam_type` varchar(50) NOT NULL,
  `registration_start_date` date NOT NULL,
  `registration_end_date` date NOT NULL,
  `exam_date` date NOT NULL,
  `description` longtext DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_testsession`
--

INSERT INTO `base_testsession` (`id`, `exam_type`, `registration_start_date`, `registration_end_date`, `exam_date`, `description`, `status`, `created_at`, `updated_at`, `created_by_id`) VALUES
(14, 'CET', '2025-06-23', '2025-06-28', '2025-06-30', NULL, 'COMPLETED', '2025-06-19 17:24:01.315848', '2025-07-02 17:29:26.425392', 177),
(15, 'EAT', '2025-06-30', '2025-07-30', '2025-07-30', NULL, 'ONGOING', '2025-06-19 17:35:10.266652', '2025-06-19 17:46:07.396707', 177),
(16, 'NAT', '2025-06-25', '2025-07-15', '2025-07-22', NULL, 'COMPLETED', '2025-06-24 18:16:35.350544', '2025-06-25 01:25:46.083564', 177),
(17, 'NAT', '2025-07-15', '2025-06-23', '2025-06-28', NULL, 'COMPLETED', '2025-06-30 13:33:08.662803', '2025-07-02 17:29:26.427207', 177),
(19, 'CET', '2025-07-04', '2025-07-17', '2025-07-24', NULL, 'ONGOING', '2025-07-02 18:55:08.609188', '2025-07-03 10:16:34.049504', 177),
(20, 'CET', '2025-07-04', '2025-07-31', '2025-08-01', NULL, 'ONGOING', '2025-07-03 14:10:07.649016', '2025-07-03 14:10:07.649036', 177),
(21, 'NAT', '2025-07-16', '2025-07-30', '2025-08-20', NULL, 'ONGOING', '2025-07-03 18:28:30.242894', '2025-07-03 18:28:30.242912', 177);

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'auth', 'user'),
(15, 'base', 'announcement'),
(8, 'base', 'appointment'),
(11, 'base', 'examresult'),
(10, 'base', 'examscore'),
(9, 'base', 'faq'),
(17, 'base', 'notification'),
(16, 'base', 'otpverification'),
(7, 'base', 'program'),
(12, 'base', 'testcenter'),
(13, 'base', 'testroom'),
(14, 'base', 'testsession'),
(5, 'contenttypes', 'contenttype'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2025-03-06 14:43:44.656613'),
(2, 'auth', '0001_initial', '2025-03-06 14:43:44.961877'),
(3, 'admin', '0001_initial', '2025-03-06 14:43:45.017549'),
(4, 'admin', '0002_logentry_remove_auto_add', '2025-03-06 14:43:45.039971'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2025-03-06 14:43:45.045971'),
(6, 'contenttypes', '0002_remove_content_type_name', '2025-03-06 14:43:45.124624'),
(7, 'auth', '0002_alter_permission_name_max_length', '2025-03-06 14:43:45.151417'),
(8, 'auth', '0003_alter_user_email_max_length', '2025-03-06 14:43:45.168212'),
(9, 'auth', '0004_alter_user_username_opts', '2025-03-06 14:43:45.183194'),
(10, 'auth', '0005_alter_user_last_login_null', '2025-03-06 14:43:45.219850'),
(11, 'auth', '0006_require_contenttypes_0002', '2025-03-06 14:43:45.222159'),
(12, 'auth', '0007_alter_validators_add_error_messages', '2025-03-06 14:43:45.226792'),
(13, 'auth', '0008_alter_user_username_max_length', '2025-03-06 14:43:45.250495'),
(14, 'auth', '0009_alter_user_last_name_max_length', '2025-03-06 14:43:45.270836'),
(15, 'auth', '0010_alter_group_name_max_length', '2025-03-06 14:43:45.296504'),
(16, 'auth', '0011_update_proxy_permissions', '2025-03-06 14:43:45.305153'),
(17, 'auth', '0012_alter_user_first_name_max_length', '2025-03-06 14:43:45.320651'),
(18, 'base', '0001_initial', '2025-03-06 14:43:45.334903'),
(19, 'sessions', '0001_initial', '2025-03-06 14:43:45.366828'),
(20, 'base', '0002_alter_program_availability_date_and_more', '2025-03-06 18:42:55.359424'),
(21, 'base', '0003_appointment_user', '2025-03-12 13:39:49.965238'),
(22, 'base', '0004_alter_appointment_status', '2025-03-18 08:54:56.734191'),
(23, 'base', '0005_faq', '2025-03-18 08:54:56.806051'),
(24, 'base', '0006_program_auto_approve_appointments', '2025-03-21 14:43:54.075223'),
(25, 'base', '0007_appointment_application_number', '2025-03-22 17:07:19.557831'),
(26, 'base', '0008_examscore', '2025-03-27 12:37:13.543834'),
(27, 'base', '0009_remove_appointment_application_number', '2025-03-27 14:56:42.718762'),
(28, 'base', '0010_examresult_examscore_app_no_examscore_exam_type_and_more', '2025-04-01 17:13:05.473142'),
(29, 'base', '0011_appointment_age_appointment_applicant_type_and_more', '2025-04-07 09:03:07.561837'),
(30, 'base', '0012_testcenter_appointment_is_submitted_and_more', '2025-04-10 14:56:26.560972'),
(31, 'base', '0013_appointment_test_center_address_and_more', '2025-04-10 19:20:10.237976'),
(32, 'base', '0014_remove_appointment_test_center_address_and_more', '2025-04-10 20:17:01.130604'),
(33, 'base', '0015_testroom_assigned_count_testroom_available_capacity', '2025-04-12 17:38:56.930287'),
(34, 'base', '0016_alter_appointment_status', '2025-04-14 18:59:56.267279'),
(35, 'base', '0017_testroom_time_slot', '2025-04-18 09:02:48.510865'),
(36, 'base', '0018_alter_appointment_status', '2025-04-19 02:49:22.035033'),
(37, 'base', '0019_announcement', '2025-04-19 07:41:45.513202'),
(38, 'base', '0020_examscore_exam_date_examscore_oapr_examscore_part1_and_more', '2025-04-20 09:47:59.951067'),
(39, 'base', '0021_appointment_assigned_test_time_slot_and_more', '2025-04-29 18:55:01.572967'),
(40, 'base', '0022_otpverification', '2025-05-15 18:34:08.157330'),
(41, 'base', '0023_alter_appointment_status', '2025-06-19 19:05:42.934540'),
(42, 'base', '0024_add_year_to_examresult', '2025-06-21 18:58:08.238613'),
(43, 'base', '0025_add_year_to_examscore', '2025-06-23 20:20:23.006046'),
(44, 'base', '0026_alter_appointment_status', '2025-07-02 20:36:46.259522'),
(45, 'base', '0027_alter_appointment_status', '2025-07-03 08:54:05.968812'),
(46, 'base', '0028_appointment_first_name_appointment_last_name_and_more', '2025-07-03 18:38:43.651882'),
(47, 'base', '0029_add_exam_date_to_appointment', '2025-07-04 17:50:21.132717'),
(48, 'base', '0030_announcement_image', '2025-07-06 19:02:18.292178'),
(49, 'base', '0031_announcement_image_url_alter_announcement_image', '2025-07-06 19:09:53.185086'),
(50, 'base', '0032_notification_and_more', '2025-07-06 20:06:15.224447'),
(51, 'base', '0033_examscore_program_alter_notification_icon_and_more', '2025-07-07 20:58:03.145445');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `base_announcement`
--
ALTER TABLE `base_announcement`
  ADD PRIMARY KEY (`id`),
  ADD KEY `base_announcement_created_by_id_60c3675f_fk_auth_user_id` (`created_by_id`);

--
-- Indexes for table `base_appointment`
--
ALTER TABLE `base_appointment`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `base_appointment_email_program_id_preferr_7b6717a8_uniq` (`email`,`program_id`,`preferred_date`,`time_slot`),
  ADD KEY `base_appointment_program_id_f914e09f_fk_base_program_id` (`program_id`),
  ADD KEY `base_appointment_user_id_6d1fd997_fk_auth_user_id` (`user_id`),
  ADD KEY `base_appointment_test_center_id_d99a909b_fk_base_testcenter_id` (`test_center_id`),
  ADD KEY `base_appointment_test_room_id_c7560800_fk_base_testroom_id` (`test_room_id`),
  ADD KEY `base_appointment_test_session_id_a5d1b9fc_fk_base_testsession_id` (`test_session_id`);

--
-- Indexes for table `base_examresult`
--
ALTER TABLE `base_examresult`
  ADD PRIMARY KEY (`id`),
  ADD KEY `base_examresult_imported_by_id_cda752b1_fk_auth_user_id` (`imported_by_id`),
  ADD KEY `base_examre_app_no_8622d4_idx` (`app_no`),
  ADD KEY `base_examre_exam_ty_f04212_idx` (`exam_type`),
  ADD KEY `base_examre_name_8aadf1_idx` (`name`),
  ADD KEY `base_examre_year_57a12b_idx` (`year`);

--
-- Indexes for table `base_examscore`
--
ALTER TABLE `base_examscore`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `appointment_id` (`appointment_id`),
  ADD KEY `base_examscore_imported_by_id_65ac3f63_fk_auth_user_id` (`imported_by_id`),
  ADD KEY `base_examsc_app_no_b1f166_idx` (`app_no`),
  ADD KEY `base_examsc_exam_ty_9851a3_idx` (`exam_type`),
  ADD KEY `base_examsc_name_95e506_idx` (`name`),
  ADD KEY `base_examsc_year_b66fd9_idx` (`year`),
  ADD KEY `base_examscore_program_id_93f0f52b_fk_base_program_id` (`program_id`);

--
-- Indexes for table `base_faq`
--
ALTER TABLE `base_faq`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `base_notification`
--
ALTER TABLE `base_notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `base_notifi_user_id_1db9b7_idx` (`user_id`,`is_read`),
  ADD KEY `base_notifi_is_glob_ce9c1f_idx` (`is_global`,`created_at`),
  ADD KEY `base_notification_created_by_id_925d977c_fk_auth_user_id` (`created_by_id`),
  ADD KEY `base_notifi_type_5f75a1_idx` (`type`,`priority`);

--
-- Indexes for table `base_otpverification`
--
ALTER TABLE `base_otpverification`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `base_program`
--
ALTER TABLE `base_program`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `base_testcenter`
--
ALTER TABLE `base_testcenter`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `base_testroom`
--
ALTER TABLE `base_testroom`
  ADD PRIMARY KEY (`id`),
  ADD KEY `base_testroom_test_center_id_ca1ebc31_fk_base_testcenter_id` (`test_center_id`);

--
-- Indexes for table `base_testsession`
--
ALTER TABLE `base_testsession`
  ADD PRIMARY KEY (`id`),
  ADD KEY `base_testsession_created_by_id_6f3e4771_fk_auth_user_id` (`created_by_id`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT for table `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=186;

--
-- AUTO_INCREMENT for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `base_announcement`
--
ALTER TABLE `base_announcement`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `base_appointment`
--
ALTER TABLE `base_appointment`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=340;

--
-- AUTO_INCREMENT for table `base_examresult`
--
ALTER TABLE `base_examresult`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=386;

--
-- AUTO_INCREMENT for table `base_examscore`
--
ALTER TABLE `base_examscore`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=244;

--
-- AUTO_INCREMENT for table `base_faq`
--
ALTER TABLE `base_faq`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `base_notification`
--
ALTER TABLE `base_notification`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `base_otpverification`
--
ALTER TABLE `base_otpverification`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `base_program`
--
ALTER TABLE `base_program`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `base_testcenter`
--
ALTER TABLE `base_testcenter`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `base_testroom`
--
ALTER TABLE `base_testroom`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `base_testsession`
--
ALTER TABLE `base_testsession`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `base_announcement`
--
ALTER TABLE `base_announcement`
  ADD CONSTRAINT `base_announcement_created_by_id_60c3675f_fk_auth_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `base_appointment`
--
ALTER TABLE `base_appointment`
  ADD CONSTRAINT `base_appointment_program_id_f914e09f_fk_base_program_id` FOREIGN KEY (`program_id`) REFERENCES `base_program` (`id`),
  ADD CONSTRAINT `base_appointment_test_center_id_d99a909b_fk_base_testcenter_id` FOREIGN KEY (`test_center_id`) REFERENCES `base_testcenter` (`id`),
  ADD CONSTRAINT `base_appointment_test_room_id_c7560800_fk_base_testroom_id` FOREIGN KEY (`test_room_id`) REFERENCES `base_testroom` (`id`),
  ADD CONSTRAINT `base_appointment_test_session_id_a5d1b9fc_fk_base_testsession_id` FOREIGN KEY (`test_session_id`) REFERENCES `base_testsession` (`id`),
  ADD CONSTRAINT `base_appointment_user_id_6d1fd997_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `base_examresult`
--
ALTER TABLE `base_examresult`
  ADD CONSTRAINT `base_examresult_imported_by_id_cda752b1_fk_auth_user_id` FOREIGN KEY (`imported_by_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `base_examscore`
--
ALTER TABLE `base_examscore`
  ADD CONSTRAINT `base_examscore_appointment_id_baf92016_fk_base_appointment_id` FOREIGN KEY (`appointment_id`) REFERENCES `base_appointment` (`id`),
  ADD CONSTRAINT `base_examscore_imported_by_id_65ac3f63_fk_auth_user_id` FOREIGN KEY (`imported_by_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `base_examscore_program_id_93f0f52b_fk_base_program_id` FOREIGN KEY (`program_id`) REFERENCES `base_program` (`id`);

--
-- Constraints for table `base_notification`
--
ALTER TABLE `base_notification`
  ADD CONSTRAINT `base_notification_created_by_id_925d977c_fk_auth_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `base_notification_user_id_09cc7a96_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `base_testroom`
--
ALTER TABLE `base_testroom`
  ADD CONSTRAINT `base_testroom_test_center_id_ca1ebc31_fk_base_testcenter_id` FOREIGN KEY (`test_center_id`) REFERENCES `base_testcenter` (`id`);

--
-- Constraints for table `base_testsession`
--
ALTER TABLE `base_testsession`
  ADD CONSTRAINT `base_testsession_created_by_id_6f3e4771_fk_auth_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
